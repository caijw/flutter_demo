// Flutter code sample for Listener

// This example makes a [Container] react to being touched, showing a count of
// the number of pointer downs and ups.

import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        // appBar: AppBar(title: const Text(_title)),
        body: MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _downCounter = 0;
  int _upCounter = 0;
  double x = 0.0;
  double y = 0.0;

  void _incrementDown(PointerEvent details) {
    _updateLocation(details);
    setState(() {
      _downCounter++;
    });
  }

  void _incrementUp(PointerEvent details) {
    _updateLocation(details);
    setState(() {
      _upCounter++;
    });
  }

  void _updateLocation(PointerEvent details) {
    setState(() {
      x = details.position.dx;
      y = details.position.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tight(Size(800.0, 400.0)),
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          RenderBox referenceBox = context.findRenderObject();
          Offset localPosition =
              referenceBox.globalToLocal(details.globalPosition);
          // print('onPanUpdate(${localPosition.dx}, ${localPosition.dy})');
          setState(() {
            x = localPosition.dx;
            y = localPosition.dy;
          });
        },
        child: Listener(
          onPointerDown: _incrementDown,
          onPointerMove: _updateLocation,
          onPointerUp: _incrementUp,
          child: Container(
            color: Colors.lightBlueAccent,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: x,
                  top: y,
                  child: Icon(Icons.home, size: 40, color: Colors.black),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
