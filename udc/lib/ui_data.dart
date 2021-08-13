abstract class BaseButtonData {
  String value;
  BaseButtonData(this.value);
}

class TextButtonData extends BaseButtonData {
  String text;
  TextButtonData(value, this.text) : super(value);
}

class ImageButtonData extends BaseButtonData {
  String imagPath;
  ImageButtonData(value, this.imagPath) : super(value);
}
