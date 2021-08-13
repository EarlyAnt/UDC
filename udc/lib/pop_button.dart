import 'package:flutter/material.dart';

class PopButton extends StatefulWidget {
  final String normalImage;
  final String tapDownImage;
  final VoidCallback onPressed;

  PopButton(this.normalImage, this.tapDownImage, {Key key, this.onPressed})
      : super(key: key);

  @override
  _PopButtonState createState() => _PopButtonState();
}

class _PopButtonState extends State<PopButton> {
  bool _tapDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Image.asset(_tapDown ? widget.tapDownImage : widget.normalImage),
      onTapDown: (details) {
        setState(() {
          _tapDown = true;
          print("onTapDown");
        });
      },
      onTapUp: (details) {
        setState(() {
          _tapDown = false;
          if (widget.onPressed != null) {
            widget.onPressed();
          }
          print("onTapUp");
        });
      },
      onTapCancel: () {
        setState(() {
          _tapDown = false;
          print("onTapCancel");
        });
      },
    );
  }
}
