import 'package:flutter/material.dart';
import 'screen_size_fit_util.dart';
import 'splash_screen.dart';

void main() {
  ScreenSizeFitUtil.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UserDataCollector',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
