// canvas 画板示例

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:touch_indicator/touch_indicator.dart';

bool useThrottle = true;
bool useDrawPath = true;

class SignaturePainter extends CustomPainter {
  SignaturePainter(this.points);

  final List<Offset> points;

  void paint(Canvas canvas, Size size) {
    print("paint, useThrottle ${useThrottle}, useDrawPath ${useDrawPath}");
    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;
    if (useDrawPath) {
      Path path = Path();
      for (int i = 0; i < points.length; i++) {
        if (points[i] == null) {
          continue;
        }
        if (i + 1 < points.length && points[i + 1] != null) {
          Path tmpPath = Path(); 
          tmpPath.moveTo(points[i].dx, points[i].dy);
          tmpPath.lineTo(points[i+1].dx, points[i+1].dy);
          path.addPath(tmpPath, Offset(0, 0));
        }
      }
      canvas.drawPath(path, paint);
    } else {
      for (int i = 0; i < points.length; i++) {
        if (points[i] == null) {
          continue;
        }
        if (i + 1 < points.length && points[i + 1] != null) {
          canvas.drawLine(points[i], points[i+1], paint);
        }
      }
    }
  }

  bool shouldRepaint(SignaturePainter other) {
    return other.points != points;
  }
}

class Signature extends StatefulWidget {
  SignatureState createState() => new SignatureState();
}

class SignatureState extends State<Signature> {
  List<Offset> _points = <Offset>[];

  @override
  void initState() {
    super.initState();
    _counterSubject.throttleTime(Duration(milliseconds: 16), trailing: true).listen((Offset localPosition) {
      setState(() {
        _points = _points;
      });
    });
  }
  final _counterSubject = BehaviorSubject<Offset>();

  Widget build(BuildContext context) {
    return new Stack(
      children: [
        GestureDetector(
          onPanStart: (DragStartDetails details) {
            int currTime = new DateTime.now().microsecondsSinceEpoch;
            int touchTime = details.sourceTimeStamp.inMicroseconds;
            // print("[dart][flutter app][main.dart][onPanStart]currTime ${currTime}, touchTime ${touchTime}, Transmission time ${currTime - touchTime} microseconds");
          },
          onPanUpdate: (DragUpdateDetails details) {
            int currTime = new DateTime.now().microsecondsSinceEpoch;
            int touchTime = details.sourceTimeStamp.inMicroseconds;
            // print("[dart][flutter app][main.dart][onPanUpdate]currTime ${currTime}, touchTime ${touchTime}, Transmission time ${currTime - touchTime} microseconds");
            RenderBox referenceBox = context.findRenderObject();
            Offset localPosition =
            referenceBox.globalToLocal(details.globalPosition);
            print("onPanUpdate, useThrottle ${useThrottle}, useDrawPath ${useDrawPath}");
            if (useThrottle) {
              _counterSubject.add(localPosition);
              _points = new List.from(_points)..add(localPosition);
            } else {
              setState(() {
                _points = new List.from(_points)..add(localPosition);
              });
            }
          },
          onPanEnd: (DragEndDetails details) {
            int currTime = new DateTime.now().microsecondsSinceEpoch;
            // print("[dart][flutter app][main.dart][onPanEnd]currTime ${currTime}");
            _points.add(null);
          },
        ),
        CustomPaint(painter: new SignaturePainter(_points))
      ],
    );
  }
}

class DemoApp extends StatelessWidget {
  Widget build(BuildContext context) => new Scaffold(body: new Signature());
}

void main() {
  runApp(new MaterialApp(
    home: TouchIndicator(
      child: new DemoApp(),
    )
  ));
}