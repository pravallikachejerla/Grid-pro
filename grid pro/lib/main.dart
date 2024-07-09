import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mindfulness Breathing',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Timer? _timer;
  int _start = 300;
  String _status = 'Inhale...';
  int _breatheCounter = 4;
  bool isTimerRunning = false;

  void startTimer() {
    if (isTimerRunning) {
      _timer?.cancel();
      setState(() {
        isTimerRunning = false;
      });
    } else {
      _timer?.cancel();
      setState(() {
        isTimerRunning = true;
      });
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_start > 0) {
          setState(() {
            _start--;
            if (_breatheCounter > 0) {
              _breatheCounter--;
            } else {
              _breatheCounter = 4;
              _status = _status == 'Inhale...' ? 'Exhale...' : 'Inhale...';
            }
          });
        } else {
          _timer?.cancel();
          setState(() {
            isTimerRunning = false;
          });
        }
      });
    }
  }

  String get timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '$minutes mins ${seconds.toString().padLeft(2, '0')} secs';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Mindfulness Breathing',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  '$_breatheCounter',
                  style: TextStyle(fontSize: 80, color: Colors.green),
                ),
                Text(
                  _status,
                  style: TextStyle(fontSize: 24, color: Colors.green),
                ),
                SizedBox(height: 20),
                IconButton(
                  icon: Icon(
                    isTimerRunning
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    size: 60,
                  ),
                  onPressed: startTimer,
                ),
                SizedBox(height: 20),
                Text(
                  timerText,
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
                SizedBox(height: 20),
                StressGraph(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StressGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(300, 150),
      painter: StressGraphPainter(),
    );
  }
}

class StressGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 3;

    final stressPaint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 3;

    final pastPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final futurePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.1, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.8, size.width * 0.9,
          size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.2, size.width * 0.1,
          size.height * 0.5);

    canvas.drawPath(path, paint);

    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.1),
      Offset(size.width * 0.5, size.height * 0.9),
      stressPaint,
    );

    canvas.drawCircle(
        Offset(size.width * 0.1, size.height * 0.5), 10, pastPaint);
    canvas.drawCircle(
        Offset(size.width * 0.9, size.height * 0.5), 10, futurePaint);
    canvas.drawCircle(
        Offset(size.width * 0.5, size.height * 0.5), 10, stressPaint);

    final textStyle = TextStyle(color: Colors.grey, fontSize: 16);
    final textSpanPast = TextSpan(text: 'PAST', style: textStyle);
    final textSpanFuture = TextSpan(text: 'FUTURE', style: textStyle);
    final textSpanPresent = TextSpan(text: 'PRESENT', style: textStyle);
    final textSpanStress = TextSpan(text: 'STRESS', style: textStyle);

    final textPainterPast =
        TextPainter(text: textSpanPast, textDirection: TextDirection.ltr);
    final textPainterFuture =
        TextPainter(text: textSpanFuture, textDirection: TextDirection.ltr);
    final textPainterPresent =
        TextPainter(text: textSpanPresent, textDirection: TextDirection.ltr);
    final textPainterStress =
        TextPainter(text: textSpanStress, textDirection: TextDirection.ltr);

    textPainterPast.layout(minWidth: 0, maxWidth: size.width);
    textPainterFuture.layout(minWidth: 0, maxWidth: size.width);
    textPainterPresent.layout(minWidth: 0, maxWidth: size.width);
    textPainterStress.layout(minWidth: 0, maxWidth: size.width);

    textPainterPast.paint(
        canvas, Offset(size.width * 0.05, size.height * 0.55));
    textPainterFuture.paint(
        canvas, Offset(size.width * 0.85, size.height * 0.55));
    textPainterPresent.paint(
        canvas, Offset(size.width * 0.45, size.height * 0.9));
    textPainterStress.paint(
        canvas, Offset(size.width * 0.52, size.height * 0.45));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
