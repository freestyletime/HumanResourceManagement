import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/Attendance.dart';

class AttendanceDetailListView extends StatelessWidget {
  final List<Attendance> data;
  final Function callback;
  final bool isListView;

  const AttendanceDetailListView(this.data,
      {this.callback, this.isListView = true});

  void _onItemClick(Attendance data) {
    if (callback != null) {
      callback(data);
    }
  }

  Widget _renderRow(int position, List<Attendance> datas) {
    if (position.isOdd) return Divider();

    final index = position ~/ 2;
    Attendance data = datas[index];
    Widget getText(String str) {
      return Text(str, style: TextStyle(fontSize: 15));
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
                getText('${Strings.attendance_info_date_time}：${data.date}'),
                Divider(),
                getText('${Strings.attendance_info_time_start}：${data.time_start}'),
                Divider(),
                getText('${Strings.attendance_info_time_end}：${data.time_end}'),
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
