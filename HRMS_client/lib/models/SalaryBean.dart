import 'package:flutter_hrms/models/IBean.dart';
import 'package:flutter_hrms/models/Salary.dart';
import 'package:flutter_hrms/models/SalaryLevel.dart';

class SalaryBean extends IBean{
  // 职级补贴信息
  SalaryLevel salaryLevel;
  // 工资信息
  List<Salary> salarys;

  SalaryBean({this.salaryLevel, this.salarys});

  SalaryBean.fromJson(Map<String, dynamic> json) {
    salaryLevel = json['salaryLevel'] == null ? null : SalaryLevel.fromJson(json['salaryLevel']);
    if (json['salarys'] != null) {
      salarys = new List<Salary>();
      json['salarys'].forEach((v) {
        salarys.add(Salary.fromJson(v));
      });
    }
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return SalaryBean.fromJson(json);
  }
}