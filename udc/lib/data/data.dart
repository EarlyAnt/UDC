import 'dart:convert';

class StoreData {
  final String? id;
  final String? name;

  StoreData(this.id, this.name);

  Map toJson() {
    Map map = Map();
    map["id"] = id;
    map["name"] = name;
    return map;
  }

  factory StoreData.fromJson(Map json) {
    return StoreData(json["id"], json["name"]);
  }
}

class TodayUserCount {
  String? date;
  int? count;

  TodayUserCount(this.date, this.count);

  Map toJson() {
    Map map = Map();
    map["date"] = date;
    map["count"] = count;
    return map;
  }

  static TodayUserCount get empty =>
      TodayUserCount(DateTime.now().toString().substring(0, 10), 0);

  factory TodayUserCount.fromJson(Map map) {
    return TodayUserCount(map["date"], map["count"]);
  }
}

class UserData {
  String? time;
  String? storeId;
  int? id;
  String? sex;
  String? family;
  String? age;
  String? expense;
  String? tag;
  String get _currentTime =>
      "${DateTime.now().toString().substring(0, 10)} ${DateTime.now().toString().substring(11, 19)}";

  UserData(
      {this.time,
      this.storeId,
      this.id,
      this.sex,
      this.family,
      this.age,
      this.expense,
      this.tag}) {
    if (this.time == null || this.time!.isEmpty) {
      this.time = this._currentTime;
    }
  }

  void setTimestamp() {
    this.time = this._currentTime;
  }

  @override
  String toString() {
    return "${time?.substring(0, 10)},${time?.substring(11, 19)},$id,$sex,$family,$age,$expense,$tag";
  }

  Map toJson() {
    Map map = Map();
    map["time"] = time;
    map["storeId"] = storeId;
    map["sex"] = sex;
    map["family"] = family;
    map["age"] = age;
    map["expense"] = expense;
    map["tag"] = tag;
    return map;
  }

  factory UserData.fromJson(Map map) {
    return UserData(
        time: map["time"],
        storeId: map["storeId"],
        sex: map["sex"],
        family: map["family"],
        age: map["age"],
        expense: map["expense"],
        tag: map["tag"]);
  }
}
