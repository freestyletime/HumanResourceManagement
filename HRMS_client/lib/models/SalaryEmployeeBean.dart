import 'package:flutter_hrms/models/Employee.dart';
import 'package:flutter_hrms/models/IBean.dart';

class SalaryEmployeeBean extends IBean {
  // 职级
  String lid;
  // 工资记录条数
  int count;
  // 员工信息
  Employee employee;

  SalaryEmployeeBean({this.lid, this.count, this.employee});

  SalaryEmployeeBean.fromJson(Map<String, dynamic> json) {
    employee = json['employee'] == null ? null : Employee.fromJson(json['employee']);
    lid = json['lid'];
    count = json['count'];
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return SalaryEmployeeBean.fromJson(json);
  }
}
