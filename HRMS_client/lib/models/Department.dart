import 'package:flutter_hrms/models/IBean.dart';

class Department extends IBean {
  int did;
  String departmentName;
  String description;
  int status;

  Department({this.did, this.departmentName, this.description});

  Department.fromJson(Map<String, dynamic> json) {
    did = json['did'];
    departmentName = json['department_name'];
    description = json['description'];
    status = json['status'];
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return Department.fromJson(json);
  }
}
