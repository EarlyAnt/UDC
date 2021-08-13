import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:udc/data.dart';

import 'image_toggle.dart';
import 'pop_button.dart';
import 'text_toggle.dart';
import 'ui_data.dart';

class Collector extends StatefulWidget {
  @override
  _CollectorState createState() => _CollectorState();
}

class _CollectorState extends State<Collector> {
  final List<ImageButtonData> _customerSexOptions = [
    ImageButtonData("男", "male"),
    ImageButtonData("女", "female")
  ];
  final List<ImageButtonData> _peopleNumberOptions = [
    ImageButtonData("1人", "father_son"),
    ImageButtonData("母子", "father_son"),
    ImageButtonData("父子", "more"),
    ImageButtonData("3+", "more")
  ];
  final List<TextButtonData> _customerAgeOptions = [
    TextButtonData("3-6岁", "3-6岁"),
    TextButtonData("7-14岁", "7-14岁"),
    TextButtonData("15岁+", "15岁+")
  ];
  final List<TextButtonData> _expenseOptions = [
    TextButtonData("1-50", "1-50"),
    TextButtonData("51-100", "51-100"),
    TextButtonData("101-200", "101-200"),
    TextButtonData("200+", "200+")
  ];
  final List<TextButtonData> _customerTagOptions = [
    TextButtonData("A", "A"),
    TextButtonData("B", "B"),
    TextButtonData("C", "C"),
    TextButtonData("D", "D")
  ];
  UserData _userData = UserData();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    return Scaffold(
      body: Stack(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Center(
                  child: Image.asset("assets/images/ui/water_mark.png"))),
          Column(
            children: [
              Column(
                children: [
                  _titleBar(),
                  Padding(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: _peopleNumber()),
                  Padding(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: _customerAge()),
                  Padding(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: _expense()),
                  Padding(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: _customerTag()),
                ],
              ),
            ],
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
    );
  }

  Widget _titleBar() {
    return Container(
      color: Colors.green,
      child: Stack(
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
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(children: [
                      Text(
                        "81",
                        style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 32,
                            fontWeight: FontWeight.w700),
                      ),
                    ]),
                  ],
                ),
              ),
              Text("提交", style: TextStyle(color: Colors.white)),
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
      ),
    );
  }

  Widget _sex() {
    return Container(
        // color: Colors.green,
        child: ImageToggle(_customerSexOptions, 46, 44, (value) {
      _userData.customerSex = value;
    },
            unselectedWidthDiff: 10,
            unselectedHeightDiff: 10,
            splitWidth: 15,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center));
  }

  Widget _peopleNumber() {
    return Column(
      children: [
        Container(
            width: double.infinity,
            child: Text("到店家庭",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600))),
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: ImageToggle(_peopleNumberOptions, 150, 45, (value) {
              _userData.peopleNumber = value;
            }, defaultItemIndex: 1)),
      ],
    );
  }

  Widget _customerAge() {
    return Column(
      children: [
        Container(
            width: double.infinity,
            child: Text("用户客层",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600))),
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: TextToggle(_customerAgeOptions, (value) {
              _userData.customerAge = value;
            }, defaultItemIndex: 1)),
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
            child: TextToggle(_expenseOptions, (value) {
              _userData.expense = value;
            }, defaultItemIndex: 2)),
      ],
    );
  }

  Widget _customerTag() {
    return Column(
      children: [
        Container(
            width: double.infinity,
            child: Text("客户标签",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600))),
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: TextToggle(_customerTagOptions, (value) {
              _userData.customerTag = value;
            }, defaultItemIndex: 1)),
      ],
    );
  }

  Widget _submit() {
    return Container(
      width: 112,
      height: 64,
      child: PopButton("assets/images/ui/submit_selected.png",
          "assets/images/ui/submit_unselected.png", onPressed: () {
        print(
            "${_userData.customerSex}, ${_userData.peopleNumber}, ${_userData.customerAge}, ${_userData.expense}, ${_userData.customerTag}");
      }),
    );
  }
}
