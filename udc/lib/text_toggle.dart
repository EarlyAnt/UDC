import 'package:flutter/material.dart';

import 'ui_data.dart';

class TextToggle extends StatefulWidget {
  final List<TextButtonData> buttonDatas;
  final int defaultItemIndex;
  final Function(String) onValueChanged;

  TextToggle(this.buttonDatas, this.onValueChanged,
      {Key key, this.defaultItemIndex = 0})
      : super(key: key);

  @override
  _TextToggleState createState() => _TextToggleState();
}

class _TextToggleState extends State<TextToggle> {
  String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.buttonDatas != null &&
            widget.defaultItemIndex >= 0 &&
            widget.defaultItemIndex < widget.buttonDatas.length
        ? widget.buttonDatas[widget.defaultItemIndex].value
        : "";
    _onValueChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: widget.buttonDatas
            .map((e) => Row(children: [
                  TExtButton(e.value, e.text, "text_button",
                      e.value == _selectedValue, _onButtonPressed),
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
      _onValueChanged();
      print("text button [$_selectedValue] pressed");
    });
  }

  void _onValueChanged() {
    if (_selectedValue != null &&
        _selectedValue.trim() != null &&
        widget.onValueChanged != null) {
      widget.onValueChanged(_selectedValue);
    }
  }
}

class TExtButton extends StatelessWidget {
  final String value;
  final String text;
  final String iconName;
  final Function(String) onPressed;
  final bool selected;

  const TExtButton(
      this.value, this.text, this.iconName, this.selected, this.onPressed,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.green,
      width: 150,
      height: 45,
      child: Stack(children: [
        RawMaterialButton(
          child: _getIconPath(),
          onPressed: () {
            onPressed(value);
          },
        ),
        IgnorePointer(
          child: Center(
            child: Text(text,
                style: TextStyle(
                    color: selected ? Colors.black : Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ]),
    );
  }

  Image _getIconPath() {
    String path = "assets/images/ui/";
    String name =
        selected ? "${iconName}_selected.png" : "${iconName}_unselected.png";
    return Image.asset("$path$name");
  }
}
