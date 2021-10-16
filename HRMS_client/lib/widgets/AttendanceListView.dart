import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/AttendanceStatistic.dart';

class AttendanceListView extends StatelessWidget {
  final List<AttendanceStatistic> data;
  final Function callback;
  final bool isListView;

  const AttendanceListView(this.data, {this.callback, this.isListView = true});

  void _onItemClick(AttendanceStatistic data) {
    if (callback != null) {
      callback(data);
    }
  }

  Widget _renderRow(int position, List<AttendanceStatistic> datas) {
    if (position.isOdd) return Divider();

    final index = position ~/ 2;
    AttendanceStatistic data = datas[index];
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
                getText('${Strings.attendance_info_date}：${data.date.substring(0, 7)}'),
                Divider(),
                getRow(
                    getText('${Strings.attendance_info_day_work}：${data.day_work}'),
                    getText('${Strings.attendance_info_day_in}：${data.day_in}')),
                Divider(),
                getRow(
                    getText('${Strings.attendance_info_day_late}：${data.day_late}'),
                    getText('${Strings.attendance_info_day_out}：${data.day_out}')),

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
