import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui_component/toast.dart';
import 'data.dart';

class StoreDataUtil {
  static const String _dataKeyStoreList = "store_list";
  static const String _dataKeySelectedStore = "selected_store";
  static SharedPreferences? _playerPrefs;
  static List<StoreData>? _storeDataList = [];
  static List<StoreData>? get storeDataList => _storeDataList;
  static String? _selectedStoreId = "";
  static String? get selectedStoreId => _selectedStoreId;

  static Future<bool> loadStoreData() async {
    bool success = await _loadStoreDataFromServer();
    if (!success) {
      success = await _loadStoreDataFromLocal();
    }
    await _loadSelectedStore();
    return success;
  }

  static String? getStoreName(String storeId) {
    if (_storeDataList == null || _storeDataList!.length == 0) {
      return null;
    }

    StoreData storeData = _storeDataList!.firstWhere(
        (element) => element.id == storeId,
        orElse: () => StoreData.empty);
    return storeData.name;
  }

  static Future _loadSelectedStore() async {
    try {
      if (_playerPrefs == null) {
        _playerPrefs = await SharedPreferences.getInstance();
      }

      _selectedStoreId = _playerPrefs?.getString(_dataKeySelectedStore);
    } catch (e) {
      print(e);
    }
  }

  static Future setSelectedStore(String storeId) async {
    try {
      if (_playerPrefs == null) {
        _playerPrefs = await SharedPreferences.getInstance();
      }

      _playerPrefs?.setString(_dataKeySelectedStore, storeId);
      print("setSelectedStore: $storeId");
      await _loadSelectedStore();
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> _loadStoreDataFromServer() async {
    try {
      if (_playerPrefs == null) {
        _playerPrefs = await SharedPreferences.getInstance();
      }

      Response response =
          await Dio().get("https://collector.kayou.gululu.com/api/store");

      List dataList = response.data["data"]["list"];
      for (var item in dataList) {
        _storeDataList?.add(StoreData(item["id"].toString(), item["name"]));
      }

      // _storeDataList = [
      //   StoreData("1", "上海张江"),
      //   StoreData("2", "上海七宝"),
      //   StoreData("3", "上海嘉定"),
      //   StoreData("4", "苏州园区"),
      //   StoreData("5", "苏州太湖"),
      // ];
      _saveStoreData(); //保存门店列表
      return true;
    } catch (e) {
      print(e);
      MessageBox.show("无法从服务器获取门店列表");
      return false;
    }
  }

  static Future<bool> _loadStoreDataFromLocal() async {
    try {
      if (_playerPrefs == null) {
        _playerPrefs = await SharedPreferences.getInstance();
      }

      if (_playerPrefs!.containsKey(_dataKeyStoreList)) {
        String? dataString = _playerPrefs!.getString(_dataKeyStoreList);
        List list = json.decode(dataString!);
        for (var item in list) {
          StoreData storeData = StoreData.fromJson(item);
          _storeDataList?.add(storeData);
        }
        return true;
      } else {
        MessageBox.show("无法从本地加载门店列表");
        return false;
      }
    } catch (e) {
      print(e);
      MessageBox.show("无法从本地加载门店列表: $e");
      return false;
    }
  }

  static void _saveStoreData() async {
    try {
      if (_playerPrefs == null) {
        _playerPrefs = await SharedPreferences.getInstance();
      }

      if (_storeDataList == null) {
        throw "argument [_storeDataList] is null";
      }

      String dataString = json.encode(_storeDataList);
      _playerPrefs?.setString(_dataKeyStoreList, dataString);
      print("_saveStoreData: $dataString");
    } catch (e) {
      print(e);
    }
  }
}
