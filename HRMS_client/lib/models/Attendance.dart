import 'package:flutter_hrms/models/IBean.dart';

class Attendance extends IBean {
  String date;
  String time_start;
  String time_end;

  Attendance({this.date, this.time_start, this.time_end});

  Attendance.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time_start = json['time_start'];
    time_end = json['time_end'];
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return Attendance.fromJson(json);
  }
}
