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
  String? storeId;
  String? sex;
  String? family;
  String? age;
  String? expense;
  String? tag;
  String get _time =>
      "${DateTime.now().toString().substring(11, 19)} ${DateTime.now().toString().substring(0, 10)}";

  @override
  String toString() {
    return "$_time,$storeId,$sex,$family,$age,$expense,$tag";
  }
}
