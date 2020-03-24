// Flutter code sample for Listener

// This example makes a [Container] react to being touched, showing a count of
// the number of pointer downs and ups.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

bool useGestureDetector = false;
bool useThrottle = true;

void main(List<String> args) {
  print(args);
  return runApp(MyApp());
}

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
  final _counterSubject = BehaviorSubject<int>();

  @override
  void initState() {
    super.initState();
    _counterSubject
        .throttleTime(Duration(milliseconds: 50), trailing: true)
        .listen((int i) {
      setState(() {
        x = x;
        y = y;
      });
    });
  }

  void onPointerDown(PointerEvent details) {
    int currTime = new DateTime.now().microsecondsSinceEpoch;
    int touchTime = details.timeStamp.inMicroseconds;
    print(
        '[dart][flutter app][main.dart][onPointerDown]cost ${currTime - touchTime} Microseconds, currTime ${currTime} Microseconds, touchTime ${touchTime} Microseconds.');
    // print(details);
    onPointerMove(details);
    setState(() {
      _downCounter++;
    });
  }

  void onPointerUp(PointerEvent details) {
    int currTime = new DateTime.now().microsecondsSinceEpoch;
    int touchTime = details.timeStamp.inMicroseconds;
    print(
        '[dart][flutter app][main.dart][onPointerUp]cost ${currTime - touchTime} Microseconds, currTime ${currTime} Microseconds, touchTime ${touchTime} Microseconds.');
    // print(details);
    onPointerMove(details);
    setState(() {
      _upCounter++;
    });
  }

  void onPointerMove(PointerEvent details) {
    int currTime = new DateTime.now().microsecondsSinceEpoch;
    int touchTime = details.timeStamp.inMicroseconds;
    print(
        '[dart][flutter app][main.dart][onPointerMove]cost ${currTime - touchTime} Microseconds, currTime ${currTime} Microseconds, touchTime ${touchTime} Microseconds.');
    if (useThrottle) {
      x = details.position.dx;
      y = details.position.dy;
      _counterSubject.add(1);
    } else {
      setState(() {
        x = details.position.dx;
        y = details.position.dy;
      });
    }
    // print(details);
  }

  @override
  Widget build(BuildContext context) {
    Widget listenerWidget = Listener(
      onPointerDown: onPointerDown,
      onPointerMove: onPointerMove,
      onPointerUp: onPointerUp,
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
    );
    if (useGestureDetector) {
      return ConstrainedBox(
        constraints: BoxConstraints.tight(Size(800.0, 400.0)),
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            print('onPanUpdate');
            print(details);
            RenderBox referenceBox = context.findRenderObject();
            Offset localPosition =
                referenceBox.globalToLocal(details.globalPosition);
            // print('onPanUpdate(${localPosition.dx}, ${localPosition.dy})');
            setState(() {
              x = localPosition.dx;
              y = localPosition.dy;
            });
          },
          child: listenerWidget,
        ),
      );
    } else {
      return ConstrainedBox(
        constraints: BoxConstraints.tight(Size(800.0, 400.0)),
        child: listenerWidget,
      );
    }
  }
}
