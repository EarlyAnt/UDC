import 'dart:convert';

class Sex {
  static const int MALE = 1; //男
  static const int FEMALE = 2; //女

  static String getText(int sex) {
    String sexString = "未知";
    switch (sex) {
      case 1:
        sexString = "男";
        break;
      case 2:
        sexString = "女";
        break;
    }
    return sexString;
  }
}

class Family {
  static const int ONE_PERSON = 1; //1人
  static const int MOTHER_SON = 2; //母子
  static const int FATHER_SON = 3; //父子
  static const int THREE_PLUS = 4; //3+

  static String getText(int family) {
    String familyString = "未知";
    switch (family) {
      case 1:
        familyString = "1人";
        break;
      case 2:
        familyString = "母子";
        break;
      case 3:
        familyString = "父子";
        break;
      case 4:
        familyString = "3+";
        break;
    }
    return familyString;
  }
}

class Age {
  static const int A_3_6 = 10; //3-6岁
  static const int A_7_14 = 20; //7-14岁
  static const int A_15_PLUS = 30; //15岁+

  static String getText(int age) {
    String ageString = "未知";
    switch (age) {
      case 10:
        ageString = "3-6岁";
        break;
      case 20:
        ageString = "7-14岁";
        break;
      case 30:
        ageString = "15岁+";
        break;
    }
    return ageString;
  }
}

class Expense {
  static const int E_1_50 = 10; //1-50
  static const int E_51_100 = 20; //51-100
  static const int E_101_200 = 30; //101-200
  static const int E_201_PLUS = 40; //201+

  static String getText(int expense) {
    String expenseString = "未知";
    switch (expense) {
      case 10:
        expenseString = "1-50";
        break;
      case 20:
        expenseString = "51-100";
        break;
      case 30:
        expenseString = "101-200";
        break;
      case 40:
        expenseString = "201+";
        break;
    }
    return expenseString;
  }
}

class Tag {
  static const int A = 1; //A
  static const int B = 2; //B
  static const int C = 3; //C
  static const int D = 4; //D

  static String getText(int tag) {
    String tagString = "未知";
    switch (tag) {
      case 1:
        tagString = "A";
        break;
      case 2:
        tagString = "B";
        break;
      case 3:
        tagString = "C";
        break;
      case 4:
        tagString = "D";
        break;
    }
    return tagString;
  }
}

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
  int? sex;
  int? family;
  int? age;
  int? expense;
  int? tag;
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
