import 'package:flutter/cupertino.dart';

abstract class BaseButtonData {
  String value;
  bool placeholder;
  BaseButtonData(this.value, this.placeholder);
}

class TextButtonData extends BaseButtonData {
  String text;
  TextButtonData(value, this.text, {placeholder = false})
      : super(value, placeholder);
}

class ImageButtonData extends BaseButtonData {
  String imagPath;
  ImageButtonData(value, this.imagPath, {placeholder = false})
      : super(value, placeholder);
}
