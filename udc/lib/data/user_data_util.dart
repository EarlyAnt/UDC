import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:udc/util/dio_util.dart';

import '../util/file_util.dart';
import 'data.dart';
import 'store_data_util.dart';

class UserDataUtil {
  static String _dataKeyCount = "data_count";
  static String _dataKeyList = "data_list";
  static Storage _storage = Storage();
  static TodayUserCount _todayUserCount = TodayUserCount.empty;
  static List<UserData>? _userDataList = [];
  static SharedPreferences? _playerPrefs;

  static TodayUserCount get todayUserCount => _todayUserCount;
  static List<UserData>? get userDataList => _userDataList;

  static Future checkNewDay() async {
    _playerPrefs = await SharedPreferences.getInstance();
    if (_playerPrefs!.containsKey(_dataKeyCount)) {
      Map map = json.decode(_playerPrefs!.getString(_dataKeyCount)!);
      _todayUserCount = TodayUserCount.fromJson(map);
    } else {
      _todayUserCount = TodayUserCount.empty;
    }

    if (!_compareData(DateTime.parse(_todayUserCount.date!), DateTime.now())) {
      _todayUserCount = TodayUserCount.empty;
      String? countDataString = json.encode(_todayUserCount);
      _playerPrefs?.setString(_dataKeyCount, countDataString);
    }
  }

  static Future readUserData() async {
    if (_playerPrefs == null) {
      _playerPrefs = await SharedPreferences.getInstance();
    }

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
  }

  static Future saveUserData(UserData userData) async {
    await _saveDataToServer(userData);
    await _saveDataToFile(userData);
    await checkNewDay();

    _todayUserCount.count = _todayUserCount.count! + 1;
    await saveTodayUserCount(todayUserCount: _todayUserCount);
  }

  static Future saveTodayUserCount({TodayUserCount? todayUserCount}) async {
    if (_playerPrefs == null) {
      _playerPrefs = await SharedPreferences.getInstance();
    }

    if (todayUserCount == null) {
      return;
    }

    _todayUserCount.date = todayUserCount.date;
    _todayUserCount.count = _todayUserCount.count;
    String? countDataString = json.encode(_todayUserCount);
    _playerPrefs?.setString(_dataKeyCount, countDataString);
  }

  static Future syncDataToSever() async {
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
          if (_isSuccess(data)) {
            //上传数据成功后，清空本地数据
            _userDataList!.clear();
            _playerPrefs?.remove(_dataKeyList);
          }
        },
        onError: (errorText) {
          print("<><CollectorView._syncDataToSever>error: $errorText");
          // MessageBox.show("同步数据失败[error]: $errorText");
        },
      );
    } catch (e) {
      print("<><CollectorView._syncDataToSever>exception: $e");
      // MessageBox.show("同步数据失败[exception]: $e");
    }
  }

  static Future _saveDataToServer(UserData userData) async {
    try {
      List<UserData> userDataList = [userData];
      Map body = Map();
      body["list"] = userDataList;

      DioUtils.postHttp(
        'https://collector.kayou.gululu.com/api/record',
        parameters: body,
        onSuccess: (data) {
          print("<><CollectorView._saveDataToServer>success: $data");
          _saveDataToBuffer(userData, _isSuccess(data));
        },
        onError: (errorText) {
          print("<><CollectorView._saveDataToServer>error: $errorText");
          // MessageBox.show("提交数据失败[error]: $errorText");
          _saveDataToBuffer(userData, false);
        },
      );
    } catch (e) {
      print("<><CollectorView._saveDataToServer>exception: $e");
      // MessageBox.show("提交数据失败[exception]: $e");
      _saveDataToBuffer(userData, false);
    }
  }

  static Future _saveDataToBuffer(UserData userData, bool uploaded) async {
    try {
      if (_playerPrefs == null) {
        _playerPrefs = await SharedPreferences.getInstance();
      }

      if (!uploaded) {
        //如果当前用户数据未上传成功，则记录到本地
        if (_userDataList == null) {
          _userDataList = [];
        }

        _userDataList!.add(userData);
        String userDataString = json.encode(_userDataList);
        _playerPrefs?.setString(_dataKeyList, userDataString);
        print("<><CollectorView._saveDataToBuffer>data: $userDataString");
      }
    } catch (e) {
      print("<><CollectorView._saveDataToBuffer>exception: $e");
      // MessageBox.show("保存本地数据失败[error]: $e");
    }
  }

  static Future _saveDataToFile(UserData userData) async {
    if (_userDataList == null) {
      return null;
    }

    try {
      String fileCountent = "";
      bool fileExisted = await _storage.fileExisted();
      if (!fileExisted) {
        fileCountent = "date,time,storeId,id,sex,family,age,expense,tag\n";
      }
      fileCountent +=
          "${userData.time?.substring(0, 10)},${userData.time?.substring(11, 19)},${StoreDataUtil.getStoreName(userData.storeId ?? "")},${userData.id},${Sex.getText(userData.sex ?? 0)},${Family.getText(userData.family ?? 0)},${Age.getText(userData.age ?? 0)},${Expense.getText(userData.expense ?? 0)},${Tag.getText(userData.tag ?? 0)}\n";

      var result =
          await _storage.writeData(fileCountent, fileMode: FileMode.append);
      print("$fileCountent");
      return result;
    } catch (e) {
      print("<><CollectorView._saveDataToFile>exception: $e");
    }
  }

  static bool _compareData(DateTime date1, DateTime date2) {
    DateTime tempDate1 = DateTime(date1.year, date1.month, date1.day);
    DateTime tempDate2 = DateTime(date2.year, date2.month, date2.day);
    return tempDate1 == tempDate2;
  }

  static bool _isSuccess(Object? data) {
    try {
      if (data == null) return false;
      Map map = json.decode(data.toString());
      bool success =
          map.containsKey("msg") && map["msg"].toString().toUpperCase() == "OK";
      return success;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
