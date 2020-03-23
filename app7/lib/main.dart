import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';



class SignaturePainter extends CustomPainter {
  SignaturePainter(this.points);

  final List<Offset> points;

  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    print(size);
    // Path path = Path();
    // path.lineTo(size.width, size.height);
    // Path path1 = Path();
    // path1.moveTo(size.width, size.height);
    // path1.lineTo(size.width, size.height/2);
    // Path path2 = Path();
    // path2.moveTo(size.width, size.height/2);
    // path2.lineTo(0, 0);
    // path.addPath(path1, Offset(0, 0));
    // path.addPath(path2, Offset(0, 0));
    // canvas.drawPath(path, paint);

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

    // print('points.length: ${points.length}');
    // Path path = new Path()..moveTo(0, 0);
    // for (int i = 0; i < points.length; i++) {
    //   if (points[i] == null) {
    //     break;
    //   }
    //   print('${i}: draw(${points[i].dx}, ${points[i].dy})');
    //   path.lineTo(points[i].dx, points[i].dy);
    //   path.moveTo(points[i].dx, points[i].dy);
    // }
    // if (points[points.length - 1] != null) {
    //   path.lineTo(points[points.length - 1].dx, points[points.length - 1].dy);
    // }
    // path.lineTo(10, 10);
    // path.lineTo(1000, 1000);
    // path.close();
    // canvas.drawPath(path, paint);
    // Paint paint = Paint()
    // ..color = Colors.red
    // ..style = PaintingStyle.stroke
    // ..strokeWidth = 8.0;
    // Path path = Path();
    // path.moveTo(size.width / 4, size.height / 4);
    // path.relativeConicTo(size.width / 4, 3 * size.height / 4, size.width, size.height, 20);
    // canvas.drawPath(path, paint);
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
    _counterSubject.throttleTime(Duration(milliseconds: 100), trailing: true).listen((Offset localPosition) {
      print(1);
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
            print("[dart][flutter app][main.dart][onPanStart]currTime ${currTime}, touchTime ${touchTime}, Transmission time ${currTime - touchTime} microseconds");
          },
          onPanUpdate: (DragUpdateDetails details) {
            int currTime = new DateTime.now().microsecondsSinceEpoch;
            int touchTime = details.sourceTimeStamp.inMicroseconds;
            print("[dart][flutter app][main.dart][onPanUpdate]currTime ${currTime}, touchTime ${touchTime}, Transmission time ${currTime - touchTime} microseconds");
            RenderBox referenceBox = context.findRenderObject();
            Offset localPosition =
            referenceBox.globalToLocal(details.globalPosition);
            _counterSubject.add(localPosition);
            print(2);
            _points = new List.from(_points)..add(localPosition);
            // setState(() {
            //   _points = new List.from(_points)..add(localPosition);
            // });
          
          },
          onPanEnd: (DragEndDetails details) {
            int currTime = new DateTime.now().microsecondsSinceEpoch;
            print("[dart][flutter app][main.dart][onPanEnd]currTime ${currTime}");
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

void main() => runApp(new MaterialApp(home: new DemoApp()));