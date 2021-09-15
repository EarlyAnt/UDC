import 'dart:ui';

class ScreenSizeFitUtil {
  // 1.基本信息
  static double _physicalWidth = 0;
  static double _physicalHeight = 0;
  static const double _standardWidth = 1200;
  static const double _standardHeight = 2000;
  static double _screenWidth = 0;
  static double _screenHeight = 0;
  static double _dpi = 0;
  static double _statusHeight = 0;
  static double _rpxHorizontal = 0;
  static double _rpxVertical = 0;
  static double _pxHorizontal = 1;
  static double _pxVertical = 1;
  static Size get screenSize => Size(_screenWidth, _screenHeight);

  static void initialize() {
    // 1.手机的物理分辨率
    _physicalWidth = window.physicalSize.width;
    _physicalHeight = window.physicalSize.height;

    // 2.获取dpr
    _dpi = window.devicePixelRatio;
    print('dpi: $_dpi');

    // 3.宽度和高度
    _screenWidth = _physicalWidth / _dpi;
    _screenHeight = _physicalHeight / _dpi;

    // 4.计算屏幕高宽比
    _rpxHorizontal = _screenWidth / _standardWidth;
    _rpxVertical = _screenHeight / _standardHeight;

    // 5.状态栏高度
    _statusHeight = window.padding.top / _dpi;

    print(
        '------------------------ScreenSizeFit.initialize------------------------');
    print('dpi: $_dpi, _statusHeight: $_statusHeight');
    print('_standardWidth: $_standardWidth, _standardHeight: $_standardHeight');
    print('_physicalWidth: $_physicalWidth, _physicalHeight: $_physicalHeight');
    print('_screenWidth: $_screenWidth, _screenHeight: $_screenHeight');
    print('_rpxHorizontal: $_rpxHorizontal, _rpxVertical: $_rpxVertical');
    print('_pxHorizontal: $_pxHorizontal, _pxVertical: $_pxVertical');
    print(
        '------------------------------------------------------------------------');
  }

  static double setVerticalPx(double size) {
    return _rpxVertical * size;
  }

  static double setHorizontalPx(double size) {
    return _rpxHorizontal * size;
  }
}

extension IntFit on int {
  double get hPx {
    return ScreenSizeFitUtil.setHorizontalPx(this.toDouble());
  }

  double get vpx {
    return ScreenSizeFitUtil.setVerticalPx(this.toDouble());
  }
}

extension DoubleFit on double {
  double get hPx => ScreenSizeFitUtil.setHorizontalPx(this);

  double get vPx {
    return ScreenSizeFitUtil.setVerticalPx(this);
  }
}
