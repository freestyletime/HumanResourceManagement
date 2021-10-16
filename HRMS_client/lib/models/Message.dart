import 'package:flutter_hrms/models/IBean.dart';

class Message extends IBean{
  String msg;

  Message({this.msg});

  @override
  fromJson(Map<String, dynamic> json) {
     msg = json['msg'];
    return this;
  }
}