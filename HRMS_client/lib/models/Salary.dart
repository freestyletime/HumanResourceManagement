import 'package:flutter_hrms/models/IBean.dart';

class Salary extends IBean {
  int eid;
  int aid;
  String date;
  String salary;
  String realSalary;
  String insurance;
  String tax;
  String preTaxSalary;
  String postTaxSalary;
  String divide;

  Salary(
      {this.eid,
      this.aid,
      this.date,
      this.salary,
      this.realSalary,
      this.insurance,
      this.tax,
      this.preTaxSalary,
      this.postTaxSalary});

  Salary.fromJson(Map<String, dynamic> json) {
    eid = json['eid'];
    aid = json['aid'];
    date = json['date'];
    salary = json['salary'];
    divide = json['divide'];
    realSalary = json['real_salary'];
    insurance = json['insurance'];
    tax = json['tax'];
    preTaxSalary = json['pre_tax_salary'];
    postTaxSalary = json['post_tax_salary'];
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return Salary.fromJson(json);
  }
}
