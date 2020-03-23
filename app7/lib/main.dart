import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MyWidget(),
  ));
}

class MyWidget extends StatefulWidget {
  @override
  MyWidgetState createState() {
    return MyWidgetState();
  }
}

class MyWidgetState extends State<MyWidget> {
  int counter = 0;
  List<String> strings = ['Flutter', 'is', 'cool', "and", "awesome!"];
  String displayedString = "Hello World!";
  double _x = 0;
  double _y = 0;

  void onPressOfButton() {
    setState(() {
      displayedString = strings[counter];
      counter = counter < 4 ? counter + 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: GestureDetector(
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: _x,
                  top: _y,
                  child: Icon(Icons.home, size: 40, color: Colors.black),
                )
              ],
            ),
            onPanUpdate: (DragUpdateDetails details) {
              RenderBox referenceBox = context.findRenderObject();
              Offset localPosition =
                  referenceBox.globalToLocal(details.globalPosition);
              print('onPanUpdate(${localPosition.dx}, ${localPosition.dy})');
              setState(() {
                _x = localPosition.dx;
                _y = localPosition.dy;
              });
            }),
      ),
    );
  }
}
