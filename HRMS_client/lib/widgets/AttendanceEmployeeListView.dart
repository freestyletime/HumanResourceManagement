import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/AttendanceEmployeeBean.dart';

class AttendanceEmployeeListView extends StatelessWidget {
  final List<AttendanceEmployeeBean> data;
  final Function callback;
  final bool isListView;

  const AttendanceEmployeeListView(this.data,
      {this.callback, this.isListView = true});

  void _onItemClick(AttendanceEmployeeBean data) {
    if (callback != null) {
      callback(data);
    }
  }

  Widget _renderRow(int position, List<AttendanceEmployeeBean> datas) {
    if (position.isOdd) return Divider();

    final index = position ~/ 2;
    AttendanceEmployeeBean data = datas[index];
    Widget getText(String str) {
      return Text(str, style: TextStyle(fontSize: 15));
    }

    Widget getRow(Widget left, Widget right) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: left,
            flex: 1,
          ),
          Expanded(
            child: right,
            flex: 1,
          )
        ],
      );
    }

    return Card(
      elevation: 5.0,
      child: InkWell(
        child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getRow(
                    getText('${Strings.employee_info_eid}：${data.employee.eid}'),
                    getText('${Strings.employee_info_phone}：${data.employee.phone}')),
                Divider(),
                getText('${Strings.employee_info_name}：${data.employee.name}'),
                Divider(),
                getText('${Strings.employee_info_email}：${data.employee.email}'),
                Divider(),
                getText('${Strings.employee_info_entryTime}：${data.employee.entryTime}'),
                Divider(),
                getText('${Strings.attendance_day}：${data.count}天'),
              ],
            )),
        onTap: () {
          _onItemClick(data);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isListView)
      return ListView.builder(
          itemCount: data.length * 2,
          itemBuilder: (context, index) => _renderRow(index, data));
    return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      return _renderRow(index, data);
    }, childCount: data.length * 2));
  }
}
