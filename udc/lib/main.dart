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
  String _fileContent = "";

  Future<File> _increase() async {
    setState(() => _fileContent += DateTime.now().toString() + "\n");
    return _storage.writeData(_fileContent);
  }

  void _decrease() async {
    _storage.readData().then((value) {
      setState(() {
        if (value != null && value.length > 0) {
          _fileContent = "";
          for (var line in value) {
            _fileContent += line + "\n";
          }
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _decrease();
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
              'File Content:',
            ),
            Text(
              '$_fileContent',
              maxLines: 20,
              style: Theme.of(context).textTheme.bodyText2,
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
