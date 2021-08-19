class UserData {
  int? id;
  String? sex;
  String? family;
  String? age;
  String? expense;
  String? tag;
  String get _date => DateTime.now().toString().substring(0, 10);
  String get _time => DateTime.now().toString().substring(11, 19);

  @override
  String toString() {
    return "$_date,$_time,$id,$sex,$family,$age,$expense,$tag";
  }
}
