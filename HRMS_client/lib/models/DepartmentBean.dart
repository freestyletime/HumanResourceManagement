import 'package:flutter_hrms/models/EmployeeBean.dart';
import 'package:flutter_hrms/models/IBean.dart';

import 'Department.dart';

class DepartmentBean extends IBean {
  // 部门信息
  Department dept;
  // 父部门信息
  Department pdept;
  // 部门人员信息
  List<EmployeeBean> employees;

  DepartmentBean({this.dept, this.pdept, this.employees});

  DepartmentBean.fromJson(Map<String, dynamic> json) {
    dept = json['dept'] == null ? null : Department.fromJson(json['dept']);
    pdept = json['pdept'] == null ? null : Department.fromJson(json['pdept']);
    if (json['employees'] != null) {
      employees = new List<EmployeeBean>();
      json['employees'].forEach((v) {
        employees.add(EmployeeBean.fromJson(v));
      });
    }
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return DepartmentBean.fromJson(json);
  }
}
