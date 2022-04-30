import 'package:flutter_hrms/models/EmployeeBean.dart';
import 'package:flutter_hrms/models/Post.dart';

import 'IBean.dart';

class PostBean extends IBean {
  // 职位信息
  Post post;
  // 部门人员信息
  List<EmployeeBean> employees;

  PostBean({this.post, this.employees});

  PostBean.fromJson(Map<String, dynamic> json) {
    post = json['post'] == null ? null : Post.fromJson(json['post']);
    if (json['employees'] != null) {
      employees = new List<EmployeeBean>();
      json['employees'].forEach((v) {
        employees.add(EmployeeBean.fromJson(v));
      });
    }
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return PostBean.fromJson(json);
  }
}