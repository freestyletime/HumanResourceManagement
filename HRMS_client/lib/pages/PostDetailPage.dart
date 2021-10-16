import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/BaseModel.dart';
import 'package:flutter_hrms/models/IModel.dart';
import 'package:flutter_hrms/models/PostBean.dart';
import 'package:flutter_hrms/pages/BasePage.dart';
import 'package:flutter_hrms/pages/CallbackController/CallbackController.dart';
import 'package:flutter_hrms/widgets/DetailHeaderView.dart';
import 'package:flutter_hrms/widgets/Dialog.dart';
import 'package:flutter_hrms/widgets/EmployeeListView.dart';

class PostDetailPage extends StatefulWidget {
  final PostBean bean;

  const PostDetailPage(this.bean);

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends BasePageState<PostDetailPage> {
  static const String MENU_RECOVERY = 'A';
  static const String MENU_DEL = 'B';

  var _controller;
  var _data = ValueNotifier<PostBean>(null);

  void _getData() {
    service
        .getPostAPI()
        .getPost(Ids.ID_GET_POST + hashCode.toString(), widget.bean.post.pid);
  }

  void _quit() {
    service
        .getPostAPI()
        .quitPost(Ids.ID_QUIT_POST + hashCode.toString(), widget.bean.post.pid);
  }

  void _recovery() {
    service.getPostAPI().recoveryPost(
        Ids.ID_RECOVERY_POST + hashCode.toString(), widget.bean.post.pid);
  }

  void _result(String val) {
    if (val != null) {
      showSnackBar(val);
      _getData();
    }
  }

  Widget _getPopup(IconData icon, String text, String id) {
    return new PopupMenuItem<String>(
        value: id,
        child: Row(
          children: <Widget>[
            Icon(icon, color: Colors.blueGrey),
            SizedBox(width: 5),
            Text(text),
          ],
        ));
  }

  @override
  void initState() {
    _controller = CallbackController(context, result: _result);
    _data.value = widget.bean;
    super.initState();
  }

  @override
  AppBar getAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(Strings.post_detail),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.refresh),
            onPressed: (() {
              if (!isLoading.value) _getData();
            })),
        PopupMenuButton<String>(
            icon: Icon(Icons.menu),
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  widget.bean.post.status == Constants.WORK_WORK
                      ? _getPopup(
                          Icons.delete_forever, Strings.post_menu_del, MENU_DEL)
                      : _getPopup(Icons.restore_from_trash,
                          Strings.post_menu_recovery, MENU_RECOVERY)
                ],
            onSelected: (String action) {
              switch (action) {
                case MENU_RECOVERY:
                  DialogUtils.alert(context,
                      text: Strings.post_recovery_hint,
                      yesCallBack: _recovery);
                  break;
                case MENU_DEL:
                  if (widget.bean.employees == null ||
                      widget.bean.employees.length == 0) {
                    DialogUtils.alert(context,
                        text: Strings.post_quit_hint, yesCallBack: _quit);
                  } else {
                    showSnackBar(Strings.post_menu_del_hint);
                  }
                  break;
              }
            }),
      ],
    );
  }

  @override
  Widget getBody() {
    Widget _getDetailElement(PostBean data) {
      var header = DetailHeaderView(
          id: data.post.pid.toString(),
          name: data.post.postName,
          other: (Strings.post_member +
              '：' +
              (data.employees == null ? '0人' : '${data.employees.length}人')));

      if (_data.value.employees == null || _data.value.employees.length == 0) {
        var empty = Text(Strings.msg_data_empty,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[header, Expanded(child: Center(child: empty))],
        );
      }

      return CustomScrollView(physics: ScrollPhysics(), slivers: <Widget>[
        SliverToBoxAdapter(child: header),
        EmployeeListView(data.employees,
            callback: _controller.itemClick, isListView: false)
      ]);
    }

    return ValueListenableBuilder<PostBean>(
        valueListenable: _data,
        builder: (context, data, _) {
          return _getDetailElement(data);
        });
  }

  @override
  void success<E extends IModel>(String id, E t) {
    if (Ids.ID_GET_POST + hashCode.toString() == id &&
        t is BaseModel<PostBean>) {
      if (Constants.STATUS_SUCCESS == t.status) {
        if (t.data != null && t.data.length != 0) {
          _data.value = t.data[0];
        }
      }
    } else if (Ids.ID_QUIT_POST + hashCode.toString() == id && t is IModel) {
      if (Constants.STATUS_SUCCESS == t.status) {
        Navigator.pop<String>(context, Strings.post_quit_success);
      }
    } else if (Ids.ID_RECOVERY_POST + hashCode.toString() == id &&
        t is IModel) {
      if (Constants.STATUS_SUCCESS == t.status) {
        Navigator.pop<String>(context, Strings.post_recovery_success);
      }
    }
  }
}
