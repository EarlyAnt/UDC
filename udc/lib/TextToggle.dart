import 'package:flutter/material.dart';

class TExtButton extends StatefulWidget {
  final String value;
  final String text;
  final String iconName;
  final Function(String) onPressed;

  const TExtButton(this.value, this.text, this.iconName, this.onPressed,
      {Key key})
      : super(key: key);

  @override
  _TExtButtonState createState() => _TExtButtonState();
}

class _TExtButtonState extends State<TExtButton> {
  bool _selected;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      IconButton(
          icon: _getIconPath(),
          onPressed: () {
            setState(() {
              _selected = !_selected;
              widget.onPressed(widget.value);
            });
          }),
      Text(widget.text,
          style: TextStyle(color: _selected ? Colors.white : Colors.grey))
    ]);
  }

  Image _getIconPath() {
    String path = "assets/images/ui/";
    String name = _selected
        ? "${widget.iconName}_selected.png"
        : "${widget.iconName}_unselected.png";
    return Image.asset("$path$name");
  }
}
