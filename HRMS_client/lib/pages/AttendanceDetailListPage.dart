import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/AttendanceBean.dart';
import 'package:flutter_hrms/models/BaseModel.dart';
import 'package:flutter_hrms/models/IModel.dart';
import 'package:flutter_hrms/pages/BasePage.dart';
import 'package:flutter_hrms/widgets/AttendanceDetailListView.dart';
import 'package:flutter_hrms/widgets/DetailHeaderView.dart';

class AttendanceDetailListPage extends StatefulWidget {
  final int eid;
  final String date;

  const AttendanceDetailListPage(this.eid, this.date);

  @override
  _AttendanceDetailListPageState createState() =>
      _AttendanceDetailListPageState();
}

class _AttendanceDetailListPageState
    extends BasePageState<AttendanceDetailListPage> {
  var _data = ValueNotifier<AttendanceBean>(null);

  void _getData() {
    service.getAttendanceAPI().getAttendance(
        Ids.ID_GET_ATTENDANCE + hashCode.toString(), widget.eid, widget.date);
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  AppBar getAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(Strings.attendance_list_detail),
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
    Widget _getDetailElement(AttendanceBean data) {
      var empty = Text(Strings.msg_data_empty, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
      if (data == null) return Center(child: empty);

      var header = DetailHeaderView(
          id: data.employee.eid.toString(),
          name: data.employee.name,
          other: widget.date + ' ' + Strings.attendance_list_detail);

      if (data.attendances == null || data.attendances.length == 0) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[header, Expanded(child: Center(child: empty))],
        );
      }

      return CustomScrollView(physics: ScrollPhysics(), slivers: <Widget>[
        SliverToBoxAdapter(child: header),
        AttendanceDetailListView(data.attendances, isListView: false)
      ]);
    }

    return ValueListenableBuilder<AttendanceBean>(
        valueListenable: _data,
        builder: (context, data, _) {
          return _getDetailElement(data);
        });
  }

  @override
  void success<E extends IModel>(String id, E t) {
    if (Ids.ID_GET_ATTENDANCE + hashCode.toString() == id &&
        t is BaseModel<AttendanceBean>) {
      if (Constants.STATUS_SUCCESS == t.status) {
        if (t.data != null && t.data.length > 0) {
          _data.value = t.data[0];
        } else {
          _data.value = null;
        }
      }
    }
  }
}
