import 'package:flutter/material.dart';

import 'data/data.dart';
import 'data/user_data_util.dart';
import 'data/ui_data.dart';
import 'ui_component/image_toggle.dart';
import 'ui_component/pop_button.dart';
import 'ui_component/text_toggle.dart';

class CollectorView extends StatefulWidget {
  @override
  _CollectorViewState createState() => _CollectorViewState();
}

class _CollectorViewState extends State<CollectorView>
    with TickerProviderStateMixin {
  final List<ImageButtonData> _sexOptions = [
    ImageButtonData(Sex.MALE, Sex.getText(Sex.MALE), "male"),
    ImageButtonData(Sex.FEMALE, Sex.getText(Sex.FEMALE), "female")
  ];
  final List<ImageButtonData> _familyOptions = [
    ImageButtonData(
        Family.ONE_PERSON, Family.getText(Family.ONE_PERSON), "one_person"),
    ImageButtonData(
        Family.MOTHER_SON, Family.getText(Family.MOTHER_SON), "mother_son"),
    ImageButtonData(
        Family.FATHER_SON, Family.getText(Family.FATHER_SON), "father_son"),
    ImageButtonData(
        Family.THREE_PLUS, Family.getText(Family.THREE_PLUS), "more")
  ];
  final List<TextButtonData> _ageOptions = [
    TextButtonData(Age.A_3_6, Age.getText(Age.A_3_6)),
    TextButtonData(Age.A_7_14, Age.getText(Age.A_7_14)),
    TextButtonData(Age.A_15_PLUS, Age.getText(Age.A_15_PLUS)),
    TextButtonData(0, "", placeholder: true)
  ];
  final List<TextButtonData> _expenseOptions = [
    TextButtonData(Expense.E_1_50, Expense.getText(Expense.E_1_50)),
    TextButtonData(Expense.E_51_100, Expense.getText(Expense.E_51_100)),
    TextButtonData(Expense.E_101_200, Expense.getText(Expense.E_101_200)),
    TextButtonData(Expense.E_201_PLUS, Expense.getText(Expense.E_201_PLUS))
  ];
  final List<TextButtonData> _tagOptions = [
    TextButtonData(Tag.A, Tag.getText(Tag.A)),
    TextButtonData(Tag.B, Tag.getText(Tag.B)),
    TextButtonData(Tag.C, Tag.getText(Tag.C)),
    TextButtonData(Tag.D, Tag.getText(Tag.D))
  ];
  final GlobalKey<ImageToggleState> _sexKey = GlobalKey();
  final GlobalKey<ImageToggleState> _familyKey = GlobalKey();
  final GlobalKey<TextToggleState> _ageKey = GlobalKey();
  final GlobalKey<TextToggleState> _expenseKey = GlobalKey();
  final GlobalKey<TextToggleState> _tagKey = GlobalKey();
  final int _bufferThreshold = 2;

  UserData _userData = UserData();
  StoreData? _storeData;
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    setState(() {
      UserDataUtil.checkNewDay();
      UserDataUtil.readUserData();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _storeData = ModalRoute.of(context)?.settings.arguments as StoreData?;
    _initAnimationController();

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
                          "${UserDataUtil.todayUserCount.count}",
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
                    child: Text(_getStoreName(),
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
            // Align(
            //   alignment: Alignment.topCenter,
            //   child: Padding(padding: EdgeInsets.only(top: 3), child: _test()),
            // ),
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

  Widget _test() {
    return IconButton(
        icon: Container(
            color: Colors.amberAccent.withAlpha(150), width: 200, height: 50),
        onPressed: () {
          setState(() {
            //设置日期为过去日期
            TodayUserCount todayUserCount = TodayUserCount.empty;
            todayUserCount.date = "2021-09-22";
            todayUserCount.count = 8;
            UserDataUtil.saveTodayUserCount(todayUserCount: todayUserCount);
          });
        });
  }

  Widget _syncData() {
    IconButton staticButton = IconButton(
        icon: Image.asset("assets/images/ui/synchronous.png",
            width: 28, height: 28),
        onPressed: () {
          print("同步数据");
          setState(() {
            UserDataUtil.syncDataToSever();
          });
        });

    ScaleTransition dynamicButton =
        ScaleTransition(scale: _controller!, child: staticButton);

    if (UserDataUtil.userDataList == null ||
        UserDataUtil.userDataList!.length < _bufferThreshold) {
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
        _saveData();
      }),
    );
  }

  void _initAnimationController() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1500),
        lowerBound: 0.8,
        upperBound: 1,
        vsync: this);
    _controller!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //动画从 controller.forward() 正向执行 结束时会回调此方法
        Future.delayed(Duration(seconds: 1)).then((value) {
          if (_controller != null) {
            _controller!.reverse();
          }
        });
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
  }

  String _getStoreName() {
    final int lengthLimit = 6;
    if (_storeData != null &&
        _storeData!.name != null &&
        _storeData!.name!.isNotEmpty) {
      if (_storeData!.name!.length <= lengthLimit) {
        return _storeData!.name!;
      } else {
        return "${_storeData!.name!.substring(0, lengthLimit - 1)}...";
      }
    } else {
      return "未知门店";
    }
  }

  void _saveData() async {
    _userData.storeId = _storeData?.id;
    _userData.id = (UserDataUtil.todayUserCount.count ?? 0) + 1;
    _userData.setTimestamp();
    await UserDataUtil.saveUserData(_userData);

    setState(() {
      //本地记录今日客人数量
      _userData = UserData();
      _sexKey.currentState?.refresh();
      _familyKey.currentState?.refresh();
      _ageKey.currentState?.refresh();
      _expenseKey.currentState?.refresh();
      _tagKey.currentState?.refresh();
    });
  }
}
