import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/PostBean.dart';
import 'package:flutter_hrms/models/PostLevel.dart';
import 'package:flutter_hrms/models/PostLevelBean.dart';

class PostExpandListView extends StatelessWidget {
  final List<PostLevelBean> data;
  final Function detailCallback;
  final Widget search;

  PostExpandListView(this.data, {this.detailCallback, this.search});

  Widget _buildHeader(PostLevel pl) {
    return Container(
      padding: EdgeInsets.all(15.0),
      height: 95.0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(pl.lid,
                style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold)),
            Padding(
              padding: EdgeInsets.only(top: 6.0),
              child: Text(pl.nickName,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemGrid(PostBean bean) {
    var widgets = List<Widget>();
    var gap = SizedBox(height: 10);
    widgets.add(Text(
      bean.post.postName,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.bold),
    ));
    widgets.add(gap);
    widgets.add(Text(Strings.employee_info_pid + '：' + bean.post.pid.toString(),
        style: TextStyle(fontSize: 12.0, color: Colors.white)));
    if (bean.employees != null) {
      widgets.add(gap);
      widgets.add(Text(Strings.post_member + '${bean.employees.length}人',
          style: TextStyle(fontSize: 10.0, color: Colors.white)));
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widgets,
          )),
          onTap: () {
            if (detailCallback != null) detailCallback(bean);
          },
        ),
      ),
    );
  }

  List<Widget> getBody() {
    var widgets = List<Widget>();
    if (search != null) widgets.add(SliverToBoxAdapter(child: search));
    for (var i = 0; i < data.length; i++) {
      PostLevelBean bean = data[i];
      if (bean != null && bean.postLevel != null && bean.posts != null) {
        widgets.add(SliverToBoxAdapter(child: _buildHeader(bean.postLevel)));
        widgets.add(SliverGrid.count(
          crossAxisCount: 3,
          children: bean.posts.map((post) {
            return _buildItemGrid(post);
          }).toList(),
        ));
      } else
        continue;
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    var body = getBody();
    return CustomScrollView(
      physics: ScrollPhysics(),
      slivers: body,
    );
  }
}
