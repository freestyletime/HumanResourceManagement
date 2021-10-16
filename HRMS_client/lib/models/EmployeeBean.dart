import 'package:flutter_hrms/models/Department.dart';
import 'package:flutter_hrms/models/Employee.dart';
import 'package:flutter_hrms/models/IBean.dart';
import 'package:flutter_hrms/models/Post.dart';
import 'package:flutter_hrms/models/PostLevel.dart';

class EmployeeBean extends IBean{
  // 员工信息
  Employee employee;
  // 直属领导信息
  Employee leader;
  // 职位信息
  Post post;
  // 职级信息
  PostLevel postLevel;
  // 部门信息
  Department dept;
  // 父部门信息
  Department pdept;

  EmployeeBean({this.employee, this.leader, this.post, this.postLevel, this.dept, this.pdept});

  EmployeeBean.fromJson(Map<String, dynamic> json){
    employee = json['employee'] == null ? null : Employee.fromJson(json['employee']);
    leader = json['leader'] == null ? null : Employee.fromJson(json['leader']);
    post = json['post'] == null ? null : Post.fromJson(json['post']);
    postLevel = json['postLevel'] == null ? null : PostLevel.fromJson(json['postLevel']);
    dept = json['dept'] == null ? null : Department.fromJson(json['dept']);
    pdept = json['pdept'] == null ? null : Department.fromJson(json['pdept']);
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return EmployeeBean.fromJson(json);
  }

}