import 'dart:convert';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:udc/collector_view.dart';

import 'data/data.dart';

class StoreListView extends StatefulWidget {
  StoreListView({Key? key}) : super(key: key);

  @override
  _StoreListViewState createState() => _StoreListViewState();
}

class _StoreListViewState extends State<StoreListView> {
  bool _loading = false;
  late List<StoreData>? _storeDataList;

  @override
  void initState() {
    super.initState();
    _loadStoreData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Align(
          alignment: Alignment.topLeft,
          child: Padding(
              padding: EdgeInsets.only(top: 15, left: 20),
              child: _titleText())),
      Center(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Image.asset("assets/images/ui/bg_01.png",
                  fit: BoxFit.fill, width: double.infinity))),
      Center(child: _loading ? _loadingText() : _storeList(context)),
    ]));
  }

  Widget _titleText() {
    return Text("门店列表",
        style: TextStyle(
            color: Color.fromRGBO(60, 60, 60, 1),
            fontSize: 24,
            fontWeight: FontWeight.bold));
  }

  Widget _loadingText() {
    return Text("loading...");
  }

  Widget _storeList(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
        // color: Colors.lightGreenAccent,
        width: screenSize.width * 0.5,
        height: screenSize.height * 0.4,
        child: GridView.builder(
            itemCount: _storeDataList!.length,
            // physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 3),
            itemBuilder: (context, index) {
              return _storeButton(_storeDataList![index]);
            }));
  }

  Widget _storeButton(StoreData? storeData) {
    return TextButton(
        style: ButtonStyle(
          //圆角
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          //边框
          side: MaterialStateProperty.all(
            BorderSide(color: Color.fromRGBO(183, 183, 183, 1), width: 2),
          ),
          //背景
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: Text(storeData?.name ?? "",
            style: TextStyle(color: Colors.black, fontSize: 20)),
        onPressed: () {
          print("selected store: ${storeData?.id}, ${storeData?.name}");
          Navigator.of(context).push(MaterialPageRoute(builder: (subContext) {
            return CollectorView();
          }));
        });
  }

  void _loadStoreData() async {
    try {
      Dio dio = Dio();
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback = (cert, host, port) {
          return true;
        };
      };

      _loading = true;
      // Response response;
      // response = await dio.get("https://collector.kayou.gululu.com/api/store");
      setState(() {
        // _storeDataList = json.decode(response.data);
        _storeDataList = [
          StoreData("1", "上海张江"),
          StoreData("2", "上海七宝"),
          StoreData("3", "上海嘉定"),
          StoreData("4", "苏州园区"),
          StoreData("5", "苏州太湖")
        ];
        _loading = false;
      });
    } catch (e) {
      print(e);
    }
  }
}
