import 'package:flutter_hrms/models/IBean.dart';

class AttendanceStatistic extends IBean {
  int eid;
  String date;
  String day_work;
  String day_in;
  String day_late;
  String day_out;

  AttendanceStatistic(
      {this.eid,
      this.date,
      this.day_work,
      this.day_in,
      this.day_late,
      this.day_out});

  AttendanceStatistic.fromJson(Map<String, dynamic> json) {
    eid = json['eid'];
    date = json['date'];
    day_work = json['day_work'];
    day_in = json['day_in'];
    day_late = json['day_late'];
    day_out = json['day_out'];
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return AttendanceStatistic.fromJson(json);
  }
}
