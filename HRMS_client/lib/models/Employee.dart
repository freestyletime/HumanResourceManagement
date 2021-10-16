import 'package:flutter_hrms/models/IBean.dart';

class Employee extends IBean {
  int eid;
  String name;
  int gender;
  String birthday;
  String hometown;
  String phone;
  String email;
  String school;
  int education;
  String entryTime;
  String leaveTime;
  int salary;
  int status;
  String description;

  Employee(
      {this.eid,
      this.name,
      this.gender,
      this.birthday,
      this.hometown,
      this.phone,
      this.email,
      this.school,
      this.education,
      this.entryTime,
      this.leaveTime,
      this.salary,
      this.status,
      this.description});

  Employee.fromJson(Map<String, dynamic> json) {
    eid = json['eid'];
    name = json['name'];
    gender = json['gender'];
    birthday = json['birthday'];
    hometown = json['hometown'];
    phone = json['phone'];
    email = json['email'];
    school = json['school'];
    education = json['education'];
    entryTime = json['entry_time'];
    leaveTime = json['leave_time'];
    salary = json['salary'];
    status = json['status'];
    description = json['description'];
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return Employee.fromJson(json);
  }
}
