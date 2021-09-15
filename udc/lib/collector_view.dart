import 'dart:io';

import 'package:flutter/material.dart';
import 'package:udc/data/data.dart';

import 'util/file_util.dart';
import 'ui_component/image_toggle.dart';
import 'ui_component/pop_button.dart';
import 'ui_component/text_toggle.dart';
import 'ui_data.dart';

class CollectorView extends StatefulWidget {
  @override
  _CollectorViewState createState() => _CollectorViewState();
}

class _CollectorViewState extends State<CollectorView> {
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
  List<String>? _userDataList = [];
  Storage _storage = Storage();
  int get _userCount => _userDataList != null && _userDataList!.length > 0
      ? _userDataList!.length - 1
      : 0;

  @override
  void initState() {
    super.initState();
    _readData();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations(
    //     [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    // SystemChrome.setEnabledSystemUIOverlays([]);

    StoreData? storeData =
        ModalRoute.of(context)?.settings.arguments as StoreData?;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 58),
              Expanded(
                  child: Container(
                      // color: Colors.lightGreenAccent,
                      alignment: Alignment.center,
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child:
                              Image.asset("assets/images/ui/water_mark.png")))),
            ],
          ),
          _options(),
          Align(
              alignment: Alignment.topCenter,
              child: _titleBar(context, storeData)),
        ],
      ),
    );
  }

  Widget _titleBar(BuildContext context, StoreData? storeData) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.2,
        // color: Colors.lightGreenAccent,
        child: Stack(
          children: [
            Image.asset("assets/images/ui/title_bar.png"),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                        padding: EdgeInsets.only(top: 9),
                        child: _back(context))),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5, top: 12),
                      child: Column(
                        children: [
                          Text("今日客人",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 6),
                          Text(DateTime.now().toString().substring(0, 10),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Column(children: [
                        Text(
                          "$_userCount",
                          style: TextStyle(
                              color: Color.fromRGBO(255, 214, 0, 1),
                              fontSize: 32,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 15)
                      ]),
                    ),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                            padding: EdgeInsets.only(top: 8, left: 30),
                            child: _syncData())),
                  ],
                ),
              ],
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                    padding: EdgeInsets.only(top: 47),
                    child: Text("${storeData?.name}",
                        style: TextStyle(color: Colors.white, fontSize: 13)))),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                  padding: EdgeInsets.only(top: 0, right: 160), child: _sex()),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                  padding: EdgeInsets.only(top: 0, right: 0), child: _submit()),
            ),
          ],
        ));
  }

  Widget _back(BuildContext context) {
    return IconButton(
        icon: Image.asset("assets/images/ui/back.png", width: 24, height: 24),
        onPressed: () {
          Navigator.of(context).pop();
        });
  }

  Widget _syncData() {
    return IconButton(
        icon: Image.asset("assets/images/ui/synchronous.png",
            width: 28, height: 28),
        onPressed: () {
          print("同步数据");
        });
  }

  Widget _options() {
    double horizontalPadding = 35;
    return Container(
      // color: Colors.lightGreenAccent,
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 58),
            Padding(
                padding: EdgeInsets.only(
                    top: 0, left: horizontalPadding, right: horizontalPadding),
                child: _family()),
            Padding(
                padding: EdgeInsets.only(
                    top: 0, left: horizontalPadding, right: horizontalPadding),
                child: _age()),
            Padding(
                padding: EdgeInsets.only(
                    top: 0, left: horizontalPadding, right: horizontalPadding),
                child: _expense()),
            Padding(
                padding: EdgeInsets.only(
                    top: 0, left: horizontalPadding, right: horizontalPadding),
                child: _tag()),
            SizedBox(width: double.infinity, height: 10),
          ]),
    );
  }

  Widget _sex() {
    return Container(
        // color: Colors.green,
        child: ImageToggle(_sexOptions, 55.2, 52.8, (value) {
      _userData.sex = value;
    },
            key: _sexKey,
            unselectedWidthDiff: 10,
            unselectedHeightDiff: 10,
            splitWidth: 20,
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
            padding: EdgeInsets.only(top: 5),
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
            padding: EdgeInsets.only(top: 5),
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
            padding: EdgeInsets.only(top: 5),
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
            padding: EdgeInsets.only(top: 5),
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
      width: 134.4,
      height: 76.8,
      child: PopButton("assets/images/ui/submit_selected.png",
          "assets/images/ui/submit_unselected.png", onPressed: () {
        _saveData();
        // _readData();
      }),
    );
  }

  Future<File?> _saveData() async {
    if (_userDataList == null) {
      _userDataList = [];
    }

    if (_userDataList!.length == 0) {
      String title = "date,time,id,sex,family,age,expense,tag";
      _userDataList!.add(title);
    }

    _userData.storeId = "";
    _userDataList!.add("${_userData.toString()}");

    String fileCountent = "";
    for (var line in _userDataList!) {
      fileCountent += "$line\n";
    }
    var result = await _storage.writeData(fileCountent);
    print("${_userData.toString()}");

    setState(() {
      _sexKey.currentState?.refresh();
      _familyKey.currentState?.refresh();
      _ageKey.currentState?.refresh();
      _expenseKey.currentState?.refresh();
      _tagKey.currentState?.refresh();
    });
    return result;
  }

  void _readData() async {
    List<String>? fileContent = await _storage.readData();
    setState(() {
      _userDataList = fileContent;
    });
  }
}
