import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/AttendanceEmployeeBean.dart';
import 'package:flutter_hrms/models/AttendanceStatistic.dart';
import 'package:flutter_hrms/models/BaseModel.dart';
import 'package:flutter_hrms/models/IModel.dart';
import 'package:flutter_hrms/pages/BasePage.dart';
import 'package:flutter_hrms/pages/CallbackController/CallbackController.dart';
import 'package:flutter_hrms/widgets/AttendanceListView.dart';
import 'package:flutter_hrms/widgets/DetailHeaderView.dart';
import 'package:flutter_hrms/widgets/SearchBox.dart';

import 'AttendanceDetailListPage.dart';

class AttendanceDetailPage extends StatefulWidget {
  final AttendanceEmployeeBean bean;

  const AttendanceDetailPage(this.bean);

  @override
  _AttendanceDetailState createState() => _AttendanceDetailState();
}

class _AttendanceDetailState extends BasePageState<AttendanceDetailPage> {
  static const String MENU_NOW = 'A';

  var _controller;
  var _source = List<AttendanceStatistic>();
  var _data = ValueNotifier<List<AttendanceStatistic>>(List());
  var _searchKey;

  void _getData() {
    AttendanceEmployeeBean data = widget.bean;
    service.getAttendanceAPI().getAllAttendance(
        Ids.ID_GET_ALL_ATTENDANCE + hashCode.toString(), data.employee.eid);
  }

  void _searchCallback(String result) {
    _searchKey = result;
    if (result == null || result.isEmpty) {
      _data.value = _source;
    } else {
      var tmp = List<AttendanceStatistic>();
      for (var i = 0; i < _source.length; i++) {
        var bean = _source[i];
        if (bean.date.substring(0, 7).contains(result)) {
          tmp.add(bean);
        }
      }
      _data.value = tmp;
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
    _controller = CallbackController(context);
    super.initState();
    _getData();
  }

  @override
  AppBar getAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(Strings.attendance_list),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.autorenew),
            onPressed: (() {
              if (!isLoading.value) _getData();
            })),
        PopupMenuButton<String>(
            icon: Icon(Icons.menu),
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  _getPopup(
                      Icons.list, Strings.attendance_menu_now, MENU_NOW)
                ],
            onSelected: (String action) {

              var now = new DateTime.now();
              switch (action) {
                case MENU_NOW:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AttendanceDetailListPage(widget.bean.employee.eid, now.toString().substring(0, 7))),
                  );
                  break;
              }
            })
      ],
    );
  }

  @override
  Widget getBody() {
    return ValueListenableBuilder<List<AttendanceStatistic>>(
        valueListenable: _data,
        builder: (context, data, _) {
          var header = DetailHeaderView(
              id: widget.bean.employee.eid.toString(),
              name: widget.bean.employee.name,
              other: data.length.toString() +
                  ' ' +
                  Strings.attendance_info_month_total);

          var search = SearchBox(
              content: _searchKey,
              hint: Strings.attendance_search_hint,
              callback: _searchCallback);

          if (data.length == 0) {
            var empty = Text(Strings.msg_data_empty,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                header,
                search,
                Expanded(child: Center(child: empty))
              ],
            );
          } else {
            return CustomScrollView(physics: ScrollPhysics(), slivers: <Widget>[
              SliverToBoxAdapter(child: header),
              SliverToBoxAdapter(child: search),
              AttendanceListView(data,
                  callback: _controller.itemClick, isListView: false)
            ]);
          }
        });
  }

  @override
  void success<E extends IModel>(String id, E t) {
    if (Ids.ID_GET_ALL_ATTENDANCE + hashCode.toString() == id &&
        t is BaseModel<AttendanceStatistic>) {
      if (Constants.STATUS_SUCCESS == t.status) {
        _searchKey = null;
        if (t.data != null && t.data.length > 0) {
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
