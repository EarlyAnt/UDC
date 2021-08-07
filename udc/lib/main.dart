import 'dart:io';
import 'package:flutter/material.dart';
import 'file_util.dart';

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Storage _storage = Storage();
  int _counter = 0;

  Future<File> _increase() async {
    setState(() => _counter++);
    return _storage.writeCounter(_counter);
  }

  Future<File> _decrease() async {
    if (_counter > 0) {
      setState(() => _counter--);
      return _storage.writeCounter(_counter);
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _storage.readCounter().then((value) {
      setState(() => _counter = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () => _increase(),
            child: new Icon(Icons.add),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () => _decrease(),
            child: new Icon(Icons.access_time),
          )
        ],
      ),
    );
  }
}
