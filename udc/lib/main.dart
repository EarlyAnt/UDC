import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
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
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: SplashScreen(),
    );
  }
}
