import 'package:flutter/material.dart';
import 'package:udc/ImageToggle.dart';

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
  final List<String> _customerAgeOptions = ["3-6岁", "7-14岁", "15岁+"];
  final List<String> _expenseOptions = ["1-50", "51-100", "101-200", "200+"];
  final List<String> _customerTagOptions = ["A", "B", "C", "D"];

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
                  _customerAge(),
                  _expense(),
                  _customerTag(),
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
    return ImageToggle(_peopleNumberOptions);
  }

  Widget _customerAge() {
    return Row(
        children: _customerAgeOptions
            .map((e) => TextButton(
                onPressed: () {
                  print("button [$e] pressed");
                },
                child: Text(e)))
            .toList());
  }

  Widget _expense() {
    return Row(
        children: _expenseOptions
            .map((e) => TextButton(
                onPressed: () {
                  print("button [$e] pressed");
                },
                child: Text(e)))
            .toList());
  }

  Widget _customerTag() {
    return Row(
        children: _customerTagOptions
            .map((e) => TextButton(
                onPressed: () {
                  print("button [$e] pressed");
                },
                child: Text(e)))
            .toList());
  }
}

abstract class BaseButtonData {
  String value;
  BaseButtonData(this.value);
}

class TextButtonData extends BaseButtonData {
  String text;
  TextButtonData(value, this.text) : super(value);
}

class ImageButtonData extends BaseButtonData {
  String imagPath;
  ImageButtonData(value, this.imagPath) : super(value);
}
