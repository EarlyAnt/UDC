import 'dart:convert';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udc/collector_view.dart';

import 'data/data.dart';
import 'util/dio_util.dart';

class StoreListView extends StatefulWidget {
  StoreListView({Key? key}) : super(key: key);

  @override
  _StoreListViewState createState() => _StoreListViewState();
}

class _StoreListViewState extends State<StoreListView> {
  bool _loading = false;
  late List<StoreData>? _storeDataList;
  int get _columnCount => _storeDataList != null && _storeDataList!.length <= 3
      ? _storeDataList!.length
      : 3;
  SharedPreferences? _playerPrefs;
  final String _dataKey = "store_list";

  @override
  void initState() {
    super.initState();
    _initPlayerPrefs();
    _loadStoreDataFromServer();
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
        width: screenSize.width * 0.17 * _columnCount,
        height: screenSize.height * 0.4,
        alignment: Alignment.center,
        child: GridView.builder(
            itemCount: _storeDataList!.length,
            shrinkWrap: true,
            // physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _columnCount,
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
          // backgroundColor: MaterialStateProperty.all(Colors.lightBlueAccent),
        ),
        child: Text(storeData?.name ?? "",
            style: TextStyle(color: Colors.black, fontSize: 20)),
        onPressed: () {
          print("selected store: ${storeData?.id}, ${storeData?.name}");
          Navigator.of(context).push(MaterialPageRoute(
              builder: (subContext) {
                return CollectorView();
              },
              settings: RouteSettings(arguments: storeData)));
        });
  }

  void _initPlayerPrefs() async {
    this._playerPrefs = await SharedPreferences.getInstance();
  }

  void _loadStoreDataFromServer() async {
    try {
      _loading = true;

      Response response =
          await Dio().get("https://collector.kayou.gululu.com/api/store");

      setState(() {
        List dataList = response.data["data"]["list"];
        _storeDataList = [];

        for (var item in dataList) {
          _storeDataList!.add(StoreData(item["id"].toString(), item["name"]));
        }
        print("_loadStoreDataFromServer: $_storeDataList");

        // _storeDataList = [
        //   StoreData("1", "上海张江"),
        //   StoreData("2", "上海七宝"),
        //   StoreData("3", "上海嘉定"),
        //   StoreData("4", "苏州园区"),
        //   StoreData("5", "苏州太湖"),
        //   // StoreData("1", "上海张江"),
        //   // StoreData("2", "上海七宝"),
        //   // StoreData("3", "上海嘉定"),
        //   // StoreData("4", "苏州园区"),
        //   // StoreData("5", "苏州太湖")
        // ];

        _saveStoreData(); //保存门店列表
        _loading = false;
      });
    } catch (e) {
      print(e);
      _loadStoreDataFromLocal();
    }
  }

  void _loadStoreDataFromLocal() {
    try {
      if (this._playerPrefs!.containsKey(_dataKey)) {
        _loading = true;

        setState(() {
          _storeDataList = [];
          String? dataString = this._playerPrefs!.getString(_dataKey);
          List list = json.decode(dataString!);
          for (var item in list) {
            StoreData storeData = StoreData.fromJson(item);
            _storeDataList?.add(storeData);
          }

          _loading = false;
        });
        print("_loadStoreDataFromLocal: $_storeDataList");
      } else {
        print("can not find the store list locally");
      }
    } catch (e) {
      print(e);
    }
  }

  void _saveStoreData() {
    try {
      if (_storeDataList == null) {
        throw "argument [_storeDataList] is null";
      }

      String dataString = json.encode(_storeDataList);
      this._playerPrefs?.setString(_dataKey, dataString);
      print("_saveStoreData: $dataString");
    } catch (e) {
      print(e);
    }
  }
}
