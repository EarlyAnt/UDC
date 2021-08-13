import 'package:flutter/material.dart';

import 'ui_data.dart';

class ImageToggle extends StatefulWidget {
  final List<ImageButtonData> buttonDatas;

  ImageToggle(this.buttonDatas, {Key key}) : super(key: key);

  @override
  _ImageToggleState createState() => _ImageToggleState();
}

class _ImageToggleState extends State<ImageToggle> {
  String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.buttonDatas[0].value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: widget.buttonDatas
            .map((e) => Row(children: [
                  ImageButton(e.value, e.imagPath, e.value == _selectedValue,
                      _onButtonPressed),
                  Visibility(
                      visible: widget.buttonDatas.indexOf(e) <
                          widget.buttonDatas.length - 1,
                      child: SizedBox(width: 60)),
                ]))
            .toList(),
      ),
    );
  }

  void _onButtonPressed(String value) {
    setState(() {
      _selectedValue = value;
      print("image button [$_selectedValue] pressed");
    });
  }
}

class ImageButton extends StatelessWidget {
  final String value;
  final String iconName;
  final Function(String) onPressed;
  final bool selected;

  const ImageButton(this.value, this.iconName, this.selected, this.onPressed,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.green,
        width: 150,
        height: 45,
        child: RawMaterialButton(
            child: _getIconPath(),
            onPressed: () {
              onPressed(value);
            }));
  }

  Image _getIconPath() {
    String path = "assets/images/ui/";
    String name =
        selected ? "${iconName}_selected.png" : "${iconName}_unselected.png";
    return Image.asset("$path$name");
  }
}
