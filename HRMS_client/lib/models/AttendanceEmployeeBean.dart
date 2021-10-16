import 'package:flutter_hrms/models/Employee.dart';
import 'package:flutter_hrms/models/IBean.dart';

class AttendanceEmployeeBean extends IBean {
  // 考勤打卡条数
  int count;
  // 员工信息
  Employee employee;

  AttendanceEmployeeBean({this.count, this.employee});

  AttendanceEmployeeBean.fromJson(Map<String, dynamic> json) {
    employee = json['employee'] == null ? null : Employee.fromJson(json['employee']);
    count = json['count'];
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return AttendanceEmployeeBean.fromJson(json);
  }
}
