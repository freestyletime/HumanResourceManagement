import 'package:flutter_hrms/models/PostBean.dart';
import 'package:flutter_hrms/models/PostLevel.dart';

import 'IBean.dart';

class PostLevelBean extends IBean {
  // 职级信息
  PostLevel postLevel;
  // 职位信息
  List<PostBean> posts;

  PostLevelBean({this.postLevel, this.posts});

  PostLevelBean.fromJson(Map<String, dynamic> json) {
    postLevel = json['postLevel'] == null ? null : PostLevel.fromJson(json['postLevel']);
    if (json['posts'] != null) {
      posts = new List<PostBean>();
      json['posts'].forEach((v) {
        posts.add(PostBean.fromJson(v));
      });
    }
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return PostLevelBean.fromJson(json);
  }
}