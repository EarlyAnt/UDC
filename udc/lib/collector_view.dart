import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udc/data/data.dart';

import 'util/dio_util.dart';
import 'ui_component/image_toggle.dart';
import 'ui_component/pop_button.dart';
import 'ui_component/text_toggle.dart';
import 'ui_data.dart';

class CollectorView extends StatefulWidget {
  @override
  _CollectorViewState createState() => _CollectorViewState();
}

class _CollectorViewState extends State<CollectorView>
    with TickerProviderStateMixin {
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

  final String _dataKeyCount = "data_count";
  final String _dataKeyList = "data_list";
  final int _bufferThreshold = 2;

  late TodayUserCount _todayUserCount;
  UserData _userData = UserData();
  List<UserData>? _userDataList = [];
  StoreData? _storeData;
  SharedPreferences? _playerPrefs;
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _readData();
  }

  @override
  Widget build(BuildContext context) {
    _storeData = ModalRoute.of(context)?.settings.arguments as StoreData?;
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1500),
        lowerBound: 0.8,
        upperBound: 1,
        vsync: this);
    _controller!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //动画从 controller.forward() 正向执行 结束时会回调此方法
        Future.delayed(Duration(seconds: 1))
            .then((value) => _controller!.reverse());
        // print("status is completed");
      } else if (status == AnimationStatus.dismissed) {
        //动画从 controller.reverse() 反向执行 结束时会回调此方法
        _controller!.forward();
        // print("status is dismissed");
      } else if (status == AnimationStatus.forward) {
        // print("status is forward");
        //执行 controller.forward() 会回调此状态
      } else if (status == AnimationStatus.reverse) {
        //执行 controller.reverse() 会回调此状态
        // print("status is reverse");
      }
    });

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
          Align(alignment: Alignment.topCenter, child: _titleBar(context)),
        ],
      ),
    );
  }

  Widget _titleBar(BuildContext context) {
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
                          "${_todayUserCount.count}",
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
                    child: Text("${_storeData?.name}",
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
    IconButton staticButton = IconButton(
        icon: Image.asset("assets/images/ui/synchronous.png",
            width: 28, height: 28),
        onPressed: () {
          print("同步数据");
          _syncDataToSever();
        });

    ScaleTransition dynamicButton =
        ScaleTransition(scale: _controller!, child: staticButton);

    if (_userDataList == null || _userDataList!.length < _bufferThreshold) {
      return staticButton;
    } else {
      _controller!.forward();
      return dynamicButton;
    }
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
        _saveDataToServer();
      }),
    );
  }

  bool _compareData(DateTime date1, DateTime date2) {
    DateTime tempDate1 = DateTime(date1.year, date1.month, date1.day);
    DateTime tempDate2 = DateTime(date2.year, date2.month, date2.day);
    return tempDate1 == tempDate2;
  }

  Future _saveDataToServer() async {
    try {
      _userData.storeId = _storeData?.id;
      List<UserData> userDataList = [_userData];
      Map body = Map();
      body["list"] = userDataList;

      DioUtils.postHttp(
        'https://collector.kayou.gululu.com/api/record',
        parameters: body,
        onSuccess: (data) {
          print("<><CollectorView._saveDataToServer>success: $data");
          _saveDataToBuffer(true);
        },
        onError: (errorText) {
          print("<><CollectorView._saveDataToServer>error: $errorText");
          _saveDataToBuffer(false);
        },
      );
    } catch (e) {
      print("<><CollectorView._saveDataToServer>exception: $e");
      _saveDataToBuffer(false);
    }
  }

  Future _saveDataToBuffer(bool uploaded) async {
    try {
      if (!uploaded) {
        //如果当前用户数据未上传成功，则记录到本地
        if (_userDataList == null) {
          _userDataList = [];
        }

        _userDataList!.add(_userData);
        String userDataString = json.encode(_userDataList);
        _playerPrefs?.setString(_dataKeyList, userDataString);
        _userData = UserData();
        print("<><CollectorView._saveDataToBuffer>data: $userDataString");
      }

      //本地记录今日客人数量
      if (_compareData(DateTime.parse(_todayUserCount.date!), DateTime.now())) {
        _todayUserCount.count = _todayUserCount.count! + 1;
      } else {
        _todayUserCount = TodayUserCount.empty;
      }
      String? countDataString = json.encode(_todayUserCount);
      _playerPrefs?.setString(_dataKeyCount, countDataString);

      setState(() {
        _sexKey.currentState?.refresh();
        _familyKey.currentState?.refresh();
        _ageKey.currentState?.refresh();
        _expenseKey.currentState?.refresh();
        _tagKey.currentState?.refresh();
      });
    } catch (e) {
      print("<><CollectorView._saveDataToBuffer>exception: $e");
    }
  }

  Future _syncDataToSever() async {
    try {
      //拷贝数据并清空本地缓存
      List<UserData> syncDataList = [];
      syncDataList.addAll(_userDataList!);

      if (syncDataList.length == 0) return;
      //上传数据
      Map body = Map();
      body["list"] = syncDataList;

      DioUtils.postHttp(
        'https://collector.kayou.gululu.com/api/record',
        parameters: body,
        onSuccess: (data) {
          print("<><CollectorView._syncDataToSever>success: $data");
          setState(() {
            //上传数据成功后，清空本地数据
            _userDataList!.clear();
            _playerPrefs?.remove(_dataKeyList);
          });
        },
        onError: (errorText) {
          print("<><CollectorView._syncDataToSever>error: $errorText");
        },
      );
    } catch (e) {
      print("<><CollectorView._syncDataToSever>exception: $e");
      _saveDataToBuffer(false);
    }
  }

  void _readData() async {
    _playerPrefs = await SharedPreferences.getInstance();
    setState(() {
      _userDataList = [];
      if (_playerPrefs!.containsKey(_dataKeyList)) {
        String? dataString = _playerPrefs!.getString(_dataKeyList);
        List list = json.decode(dataString!);
        for (var item in list) {
          UserData userData = UserData.fromJson(item);
          _userDataList?.add(userData);
        }

        print(
            "<><CollectorView._readData>data list length: ${_userDataList?.length}");
      } else {
        print("<><CollectorView._readData>can not find the user data locally");
      }

      if (_playerPrefs!.containsKey(_dataKeyCount)) {
        Map map = json.decode(_playerPrefs!.getString(_dataKeyCount)!);
        _todayUserCount = TodayUserCount.fromJson(map);
      } else {
        _todayUserCount = TodayUserCount.empty;
      }
    });
  }
}
