import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        home: PathExample(),
      ),
    );

class PathExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PathPainter(),
    );
  }
}

class PathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    print(size);
    Path path = Path();
    path.lineTo(size.width, size.height);
    Path path1 = Path();
    path1.moveTo(size.width, size.height);
    path1.lineTo(size.width, size.height/2);
    Path path2 = Path();
    path2.moveTo(size.width, size.height/2);
    path2.lineTo(0, 0);
    path.addPath(path1, Offset(0, 0));
    path.addPath(path2, Offset(0, 0));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}