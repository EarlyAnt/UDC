abstract class BaseButtonData {
  int value;
  String text;
  bool placeholder;
  BaseButtonData(this.value, this.text, this.placeholder);
}

class TextButtonData extends BaseButtonData {
  TextButtonData(value, text, {placeholder = false})
      : super(value, text, placeholder);
}

class ImageButtonData extends BaseButtonData {
  String imagPath;
  ImageButtonData(value, text, this.imagPath, {placeholder = false})
      : super(value, text, placeholder);
}
