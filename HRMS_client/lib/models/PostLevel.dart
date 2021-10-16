import 'package:flutter_hrms/models/IBean.dart';

class PostLevel extends IBean {
  String lid;
  int level;
  String nickName;
  String description;

  PostLevel({this.lid, this.level, this.nickName, this.description});

  PostLevel.fromJson(Map<String, dynamic> json) {
    lid = json['lid'];
    level = json['level'];
    nickName = json['nick_name'];
    description = json['description'];
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return PostLevel.fromJson(json);
  }
}
