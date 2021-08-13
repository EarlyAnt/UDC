import 'package:flutter/material.dart';

import 'image_toggle.dart';
import 'text_toggle.dart';
import 'ui_data.dart';

class Collector extends StatefulWidget {
  @override
  _CollectorState createState() => _CollectorState();
}

class _CollectorState extends State<Collector> {
  final List<String> _customerSexOptions = ["男", "女"];
  final List<ImageButtonData> _peopleNumberOptions = [
    ImageButtonData("1人", "father_son"),
    ImageButtonData("父子", "more"),
    ImageButtonData("母子", "father_son"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(child: Image.asset("assets/images/ui/water_mark.png")),
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
        ],
      ),
    );
  }

  Widget _peopleNumber() {
    return Column(
      children: [
        Container(
            width: double.infinity,
            child: Text("到店家庭",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: ImageToggle(_peopleNumberOptions)),
      ],
    );
  }

  Widget _customerAge() {
    return Column(
      children: [
        Container(
            width: double.infinity,
            child: Text("用户客层",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: TextToggle(_customerAgeOptions)),
      ],
    );
  }

  Widget _expense() {
    return Column(
      children: [
        Container(
            width: double.infinity,
            child: Text("消费区间",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: TextToggle(_expenseOptions)),
      ],
    );
  }

  Widget _customerTag() {
    return Column(
      children: [
        Container(
            width: double.infinity,
            child: Text("客户标签",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: TextToggle(_customerTagOptions)),
      ],
    );
  }
}
