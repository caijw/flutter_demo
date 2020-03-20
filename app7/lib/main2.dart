import 'package:flutter/material.dart';
import 'dart:async';
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'test',
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 500,
            height: 500,
            child: CustomPaint(
              child: Center(
                child: Text('111'),
              ),
              painter: MyPainter(),
            ),
          ),)
      ));
  }
}

class MyPainter extends CustomPainter {
  Paint _paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;
  @override
  void paint(Canvas canvas, Size size) {
    double end = 40.0;
    canvas.drawLine(Offset(20, 20), Offset(end, end), _paint);
    Timer.periodic(new Duration(seconds: 1), (timer) {
      end += 20;
      // canvas.drawLine(Offset(20, 20), Offset(end, end), _paint);
      print("Yeah, this line is printed after 3 seconds");
    });
  }
  bool shouldRepaint(MyPainter other) {
    return true;
  }

}

// void main(List<String> args) {
//   runApp(MyApp());
// }