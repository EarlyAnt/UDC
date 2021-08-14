import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:udc/data.dart';

import 'file_util.dart';
import 'image_toggle.dart';
import 'pop_button.dart';
import 'text_toggle.dart';
import 'ui_data.dart';

class Collector extends StatefulWidget {
  @override
  _CollectorState createState() => _CollectorState();
}

class _CollectorState extends State<Collector> {
  final List<ImageButtonData> _sexOptions = [
    ImageButtonData("男", "male"),
    ImageButtonData("女", "female")
  ];
  final List<ImageButtonData> _familyOptions = [
    ImageButtonData("1人", "one_person"),
    ImageButtonData("母子", "mother_son"),
    ImageButtonData("父子", "father_son"),
    ImageButtonData("3+", "more")
  ];
  final List<TextButtonData> _ageOptions = [
    TextButtonData("3-6岁", "3-6岁"),
    TextButtonData("7-14岁", "7-14岁"),
    TextButtonData("15岁+", "15岁+"),
    TextButtonData("", "", placeholder: true)
  ];
  final List<TextButtonData> _expenseOptions = [
    TextButtonData("1-50", "1-50"),
    TextButtonData("51-100", "51-100"),
    TextButtonData("101-200", "101-200"),
    TextButtonData("200+", "200+")
  ];
  final List<TextButtonData> _tagOptions = [
    TextButtonData("A", "A"),
    TextButtonData("B", "B"),
    TextButtonData("C", "C"),
    TextButtonData("D", "D")
  ];
  final GlobalKey<ImageToggleState> _sexKey = GlobalKey();
  final GlobalKey<ImageToggleState> _familyKey = GlobalKey();
  final GlobalKey<TextToggleState> _ageKey = GlobalKey();
  final GlobalKey<TextToggleState> _expenseKey = GlobalKey();
  final GlobalKey<TextToggleState> _tagKey = GlobalKey();

  UserData _userData = UserData();
  List<String> _userDataList = [];
  Storage _storage = Storage();
  int get _userCount => _userDataList != null && _userDataList.length > 0
      ? _userDataList.length - 1
      : 0;

  @override
  void initState() {
    super.initState();
    _readData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 130, left: 10, right: 10),
                child: Image.asset("assets/images/ui/water_mark.png")),
            Align(alignment: Alignment.topCenter, child: _titleBar()),
            Padding(
              padding: EdgeInsets.only(top: 58),
              child: Column(
                children: [
                  Column(children: [
                    Padding(
                        padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                        child: _family()),
                    Padding(
                        padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                        child: _age()),
                    Padding(
                        padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                        child: _expense()),
                    Padding(
                        padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                        child: _tag()),
                    SizedBox(width: double.infinity, height: 20),
                  ]),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(top: 0, right: 0),
                child: _submit(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleBar() {
    return Stack(
      children: [
        Center(
          child: Image.asset("assets/images/ui/title_bar.png"),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 5),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text("今日客人",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(DateTime.now().toString().substring(0, 10),
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                  SizedBox(width: 10),
                  Column(children: [
                    Text(
                      "$_userCount",
                      style: TextStyle(
                          color: Color.fromRGBO(255, 214, 0, 1),
                          fontSize: 32,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 15),
                  ]),
                ],
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(top: 0, right: 135),
            child: _sex(),
          ),
        ),
      ],
    );
  }

  Widget _sex() {
    return Container(
        // color: Colors.green,
        child: ImageToggle(_sexOptions, 46, 44, (value) {
      _userData.sex = value;
    },
            key: _sexKey,
            unselectedWidthDiff: 10,
            unselectedHeightDiff: 10,
            splitWidth: 15,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center));
  }

  Widget _family() {
    return Column(
      children: [
        Container(
            width: double.infinity,
            child: Text("到店家庭",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600))),
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: ImageToggle(_familyOptions, 150, 45, (value) {
              _userData.family = value;
            },
                key: _familyKey,
                defaultItemIndex: 1,
                splitWidth: 0,
                mainAxisAlignment: MainAxisAlignment.spaceBetween)),
      ],
    );
  }

  Widget _age() {
    return Column(
      children: [
        Container(
            width: double.infinity,
            child: Text("用户客层",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600))),
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: TextToggle(_ageOptions, 150, 45, (value) {
              _userData.age = value;
            },
                key: _ageKey,
                defaultItemIndex: 1,
                mainAxisAlignment: MainAxisAlignment.spaceBetween)),
      ],
    );
  }

  Widget _expense() {
    return Column(
      children: [
        Container(
            width: double.infinity,
            child: Text("消费区间",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600))),
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: TextToggle(_expenseOptions, 150, 45, (value) {
              _userData.expense = value;
            },
                key: _expenseKey,
                defaultItemIndex: 2,
                mainAxisAlignment: MainAxisAlignment.spaceBetween)),
      ],
    );
  }

  Widget _tag() {
    return Column(
      children: [
        Container(
            width: double.infinity,
            child: Text("客户标签",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600))),
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: TextToggle(_tagOptions, 150, 45, (value) {
              _userData.tag = value;
            },
                key: _tagKey,
                defaultItemIndex: 1,
                mainAxisAlignment: MainAxisAlignment.spaceBetween)),
      ],
    );
  }

  Widget _submit() {
    return Container(
      width: 112,
      height: 64,
      child: PopButton("assets/images/ui/submit_selected.png",
          "assets/images/ui/submit_unselected.png", onPressed: () {
        _saveData();
      }),
    );
  }

  Future<File> _saveData() async {
    bool fileExisted = await _storage.fileExists();

    if (_userDataList == null) {
      _userDataList = [];
    }

    if (!fileExisted) {
      String title = "date,time,id,sex,family,age,expense,tag\n";
      _userDataList.add(title);
    }

    _userData.id = _userCount + 1;
    _userDataList.add("${_userData.toString()}\n");

    String fileCountent = "";
    for (var line in _userDataList) {
      fileCountent += line;
    }
    var result = await _storage.writeData(fileCountent);
    print("${_userData.toString()}");

    setState(() {
      _sexKey.currentState.refresh();
      _familyKey.currentState.refresh();
      _ageKey.currentState.refresh();
      _expenseKey.currentState.refresh();
      _tagKey.currentState.refresh();
    });
    return result;
  }

  void _readData() async {
    _storage.readData().then((value) {
      setState(() {
        _userDataList = value;
      });
    });
  }
}
