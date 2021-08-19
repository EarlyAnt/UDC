import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'file_util.dart';
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Storage _storage = Storage();
  String _fileContent = "";
  final List<String> _customerSexOptions = ["男", "女"];
  final List<String> _peopleNumberOptions = ["1人", "父子", "母子", "3+"];
  final List<String> _customerAgeOptions = ["3-6岁", "7-14岁", "15岁+"];
  final List<String> _expenseOptions = ["1-50", "51-100", "101-200", "200+"];
  final List<String> _customerTagOptions = ["A", "B", "C", "D"];
  final Random _random = Random();

  Future<File> _saveData() async {
    int index1 = _random.nextInt(100) % _customerSexOptions.length;
    int index2 = _random.nextInt(100) % _peopleNumberOptions.length;
    int index3 = _random.nextInt(100) % _customerAgeOptions.length;
    int index4 = _random.nextInt(100) % _expenseOptions.length;
    int index5 = _random.nextInt(100) % _customerTagOptions.length;

    var data =
        '${_customerSexOptions[index1]},${_peopleNumberOptions[index2]},${_customerAgeOptions[index3]},${_expenseOptions[index4]},${_customerTagOptions[index5]}';
    setState(() => _fileContent +=
        DateTime.now().toString().substring(11, 21) + "->$data\n");
    return _storage.writeData(_fileContent);
  }

  void _readData() async {
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
    _readData();
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
            onPressed: () => _saveData(),
            child: new Icon(Icons.add),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () => _readData(),
            child: new Icon(Icons.access_time),
          )
        ],
      ),
    );
  }
}
