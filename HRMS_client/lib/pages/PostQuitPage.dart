import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/BaseModel.dart';
import 'package:flutter_hrms/models/IModel.dart';
import 'package:flutter_hrms/models/PostBean.dart';
import 'package:flutter_hrms/models/PostLevelBean.dart';
import 'package:flutter_hrms/pages/BasePage.dart';
import 'package:flutter_hrms/widgets/PostExpandListView.dart';
import 'package:flutter_hrms/widgets/SearchBox.dart';

import 'CallbackController/CallbackController.dart';

class PostQuitPage extends StatefulWidget {
  static final String tag = 'post-quit-page';
  PostQuitPage({Key key}) : super(key: key);

  @override
  _PostQuitPageState createState() => _PostQuitPageState();
}

class _PostQuitPageState extends BasePageState<PostQuitPage> {
  var _controller;
  var _source = List<PostLevelBean>();
  var _data = ValueNotifier<List<PostLevelBean>>(List());
  var _searchKey;

  void _getData() {
    service.getPostAPI().getAllQuitPostByLevel(
        Ids.ID_GET_ALL_QUIT_POST_BY_LEVEL + hashCode.toString());
  }

  void _result(String val) {
    if (val != null) {
      showSnackBar(val);
      _getData();
    }
  }

  void _searchCallback(String result) {
    _searchKey = result;
    if (result == null || result.isEmpty) {
      _data.value = _source;
    } else {
      var tmp = List<PostLevelBean>();
      for (var i = 0; i < _source.length; i++) {
        var bean = _source[i];
        if (bean.posts != null && bean.posts.length > 0) {
          var posts = bean.posts;
          var tmp2 = List<PostBean>();
          for (int n = 0; n < posts.length; n++) {
            var post = posts[n];
            if (post.post.postName.contains(result)) tmp2.add(post);
          }

          if (tmp2.length > 0) {
            tmp.add(PostLevelBean(postLevel: bean.postLevel, posts: tmp2));
          }
        }
      }
      _data.value = tmp;
    }
  }

  @override
  void initState() {
    _controller = CallbackController(context, result: _result);
    super.initState();
    _getData();
  }

  @override
  AppBar getAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(Strings.post_menu_del_list),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.autorenew),
            onPressed: (() {
              if (!isLoading.value) _getData();
            }))
      ],
    );
  }

  @override
  Widget getBody() {
    return ValueListenableBuilder<List<PostLevelBean>>(
        valueListenable: _data,
        builder: (context, data, _) {
          var search = SearchBox(
              content: _searchKey,
              hint: Strings.post_search_hint,
              callback: _searchCallback);

          if (data.length == 0) {
            var empty = Text(Strings.msg_data_empty,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[search, Expanded(child: Center(child: empty))],
            );
          }

          return PostExpandListView(
            data,
            search: search,
            detailCallback: _controller.itemClick,
          );
        });
  }

  @override
  void success<E extends IModel>(String id, E t) {
    if (Ids.ID_GET_ALL_QUIT_POST_BY_LEVEL + hashCode.toString() == id &&
        t is BaseModel<PostLevelBean>) {
      if (Constants.STATUS_SUCCESS == t.status) {
        _searchKey = null;
        if (t.data != null && t.data.length != 0) {
          _source = t.data;
          _data.value = t.data;
        } else {
          _source.clear();
          _data.value.clear();
        }
      }
    }
  }
}
