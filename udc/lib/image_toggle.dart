import 'package:flutter/material.dart';

import 'ui_data.dart';

class ImageToggle extends StatefulWidget {
  final List<ImageButtonData> buttonDatas;
  final double buttonWidth;
  final double buttonHeight;
  final double unselectedWidthDiff;
  final double unselectedHeightDiff;
  final double splitWidth;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  final int defaultItemIndex;
  final Function(String) onValueChanged;

  ImageToggle(this.buttonDatas, this.buttonWidth, this.buttonHeight,
      this.onValueChanged,
      {Key? key,
      this.unselectedWidthDiff = 0,
      this.unselectedHeightDiff = 0,
      this.splitWidth = 0,
      this.mainAxisSize = MainAxisSize.max,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.defaultItemIndex = 0})
      : super(key: key);

  @override
  ImageToggleState createState() => ImageToggleState();
}

class ImageToggleState extends State<ImageToggle> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: widget.mainAxisSize,
        mainAxisAlignment: widget.mainAxisAlignment,
        children: widget.buttonDatas
            .map((e) => Row(children: [
                  ImageButton(
                    e.value,
                    e.imagPath,
                    e.value == _selectedValue,
                    _onButtonPressed,
                    width: widget.buttonWidth,
                    height: widget.buttonHeight,
                    unselectedWidthDiff: widget.unselectedWidthDiff,
                    unselectedHeightDiff: widget.unselectedHeightDiff,
                  ),
                  Visibility(
                      visible: widget.buttonDatas.indexOf(e) <
                          widget.buttonDatas.length - 1,
                      child: SizedBox(width: widget.splitWidth)),
                ]))
            .toList(),
      ),
    );
  }

  void _onButtonPressed(String value) {
    setState(() {
      _selectedValue = value;
      _onValueChanged();
      print("image button [$_selectedValue] pressed");
    });
  }

  void _onValueChanged() {
    if (_selectedValue != null &&
        _selectedValue?.trim() != null &&
        widget.onValueChanged != null) {
      widget.onValueChanged(_selectedValue ?? "");
    }
  }

  void refresh() {
    _selectedValue = widget.buttonDatas != null &&
            widget.defaultItemIndex >= 0 &&
            widget.defaultItemIndex < widget.buttonDatas.length
        ? widget.buttonDatas[widget.defaultItemIndex].value
        : "";
    _onValueChanged();
  }
}

class ImageButton extends StatelessWidget {
  final String value;
  final String iconName;
  final double width;
  final double height;
  final double unselectedWidthDiff;
  final double unselectedHeightDiff;
  final Function(String) onPressed;
  final bool selected;

  const ImageButton(this.value, this.iconName, this.selected, this.onPressed,
      {Key? key,
      this.width = 150,
      this.height = 45,
      this.unselectedWidthDiff = 0,
      this.unselectedHeightDiff = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.green,
        width: width,
        height: height,
        child: RawMaterialButton(
            child: Align(alignment: Alignment.topCenter, child: _getIconPath()),
            onPressed: () {
              onPressed(value);
            }));
  }

  Image _getIconPath() {
    String path = "assets/images/ui/";
    String name =
        selected ? "${iconName}_selected.png" : "${iconName}_unselected.png";
    return Image.asset(
      "$path$name",
      width: width - (selected ? 0 : unselectedWidthDiff),
      height: height - (selected ? 0 : unselectedHeightDiff),
    );
  }
}
