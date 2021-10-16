import 'package:flutter_hrms/models/Attendance.dart';
import 'package:flutter_hrms/models/Employee.dart';
import 'package:flutter_hrms/models/IBean.dart';

class AttendanceBean extends IBean {
  // 考勤打卡条数
  List<Attendance> attendances;
  // 员工信息
  Employee employee;

  AttendanceBean({this.attendances, this.employee});

  AttendanceBean.fromJson(Map<String, dynamic> json) {
    employee = json['employee'] == null ? null : Employee.fromJson(json['employee']);
        if (json['attendances'] != null) {
      attendances = new List<Attendance>();
      json['attendances'].forEach((v) {
        attendances.add(Attendance.fromJson(v));
      });
    }
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return AttendanceBean.fromJson(json);
  }
}
