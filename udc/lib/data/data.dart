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

class UserData {
  String? time;
  String? storeId;
  String? sex;
  String? family;
  String? age;
  String? expense;
  String? tag;
  bool? upload;
  String get _currentTime =>
      "${DateTime.now().toString().substring(0, 10)} ${DateTime.now().toString().substring(11, 19)}";

  UserData(
      {this.time,
      this.storeId,
      this.sex,
      this.family,
      this.age,
      this.expense,
      this.tag,
      this.upload});

  UserData getFullData() {
    return UserData.fromJson(this.toJson());
  }

  @override
  String toString() {
    return json.encode(toJson());
  }

  Map toJson() {
    Map map = Map();
    map["time"] = time == null || time!.isEmpty ? _currentTime : time;
    map["storeId"] = storeId;
    map["sex"] = sex;
    map["family"] = family;
    map["age"] = age;
    map["expense"] = expense;
    map["tag"] = tag;
    map["upload"] = upload;
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
        tag: map["tag"],
        upload: map["upload"]);
  }
}
