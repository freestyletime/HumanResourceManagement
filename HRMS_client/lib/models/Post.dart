import 'package:flutter_hrms/models/IBean.dart';

class Post extends IBean {
  int pid;
  String postName;
  String description;
  int status;

  Post({this.pid, this.postName, this.description});

  Post.fromJson(Map<String, dynamic> json) {
    pid = json['pid'];
    postName = json['post_name'];
    description = json['description'];
    status = json['status'];
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return Post.fromJson(json);
  }
}
