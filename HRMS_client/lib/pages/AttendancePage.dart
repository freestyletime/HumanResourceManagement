import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/AttendanceEmployeeBean.dart';
import 'package:flutter_hrms/models/BaseModel.dart';
import 'package:flutter_hrms/models/IModel.dart';
import 'package:flutter_hrms/pages/BasePage.dart';
import 'package:flutter_hrms/pages/CallbackController/CallbackController.dart';
import 'package:flutter_hrms/widgets/AttendanceEmployeeListView.dart';
import 'package:flutter_hrms/widgets/SearchBox.dart';

class AttendancePage extends StatefulWidget {
  static final String tag = 'attendance-page';
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends BasePageState<AttendancePage> {
  var _controller;
  var _source = List<AttendanceEmployeeBean>();
  var _data = ValueNotifier<List<AttendanceEmployeeBean>>(List());
  var _searchKey;

  void _getData() {
    service.getAttendanceAPI().getAllAttendanceEmployee(
        Ids.ID_GET_ALL_ATTENDANCE_EMP + hashCode.toString());
  }

  void _searchCallback(String result) {
    _searchKey = result;
    if (result == null || result.isEmpty) {
      _data.value = _source;
    } else {
      var tmp = List<AttendanceEmployeeBean>();
      for (var i = 0; i < _source.length; i++) {
        var bean = _source[i];
        if (bean.employee.name.contains(result)) {
          tmp.add(bean);
        }
      }
      _data.value = tmp;
    }
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
      title: Text(Strings.attendance),
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
        return ValueListenableBuilder<List<AttendanceEmployeeBean>>(
        valueListenable: _data,
        builder: (context, data, _) {
          var search = SearchBox(
              content: _searchKey,
              hint: Strings.employee_info_name_hint,
              callback: _searchCallback);

          if (data.length == 0) {
            var empty = Text(Strings.msg_data_empty,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[search, Expanded(child: Center(child: empty))],
            );
          } else {
            return CustomScrollView(physics: ScrollPhysics(), slivers: <Widget>[
              SliverToBoxAdapter(child: search),
              AttendanceEmployeeListView(data, callback: _controller.itemClick, isListView: false)
            ]);
          }
        });
  }

  @override
  void success<E extends IModel>(String id, E t) {
    if (Ids.ID_GET_ALL_ATTENDANCE_EMP + hashCode.toString() == id &&
        t is BaseModel<AttendanceEmployeeBean>) {
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
