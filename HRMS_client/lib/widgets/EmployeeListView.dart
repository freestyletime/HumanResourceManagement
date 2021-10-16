import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/EmployeeBean.dart';

class EmployeeListView extends StatelessWidget {
  final List<EmployeeBean> data;
  final Function callback;
  final bool isListView;

  EmployeeListView(this.data, {this.callback, this.isListView = true});

  void _onItemClick(EmployeeBean data) {
    if (callback != null) {
      callback(data);
    }
  }

  Widget _renderRow(int position, List<EmployeeBean> datas) {
    if (position.isOdd) return Divider();

    final index = position ~/ 2;
    EmployeeBean data = datas[index];
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

    String education = Strings.employee_bachelor;
    String status = Strings.employee_stay_work;

    if (Constants.EDUCATION_OTHER == data.employee.education)
      education = Strings.employee_education_other;
    else if (Constants.EDUCATION_COLLEGE == data.employee.education)
      education = Strings.employee_college;
    else if (Constants.EDUCATION_BACHELOR == data.employee.education)
      education = Strings.employee_bachelor;
    else if (Constants.EDUCATION_MASTER == data.employee.education)
      education = Strings.employee_master;
    else if (Constants.EDUCATION_PHD == data.employee.education)
      education = Strings.employee_phd;

    if (Constants.WORK_LEAVE == data.employee.status)
      status = Strings.employee_leave_work;

    return Card(
      elevation: 5.0,
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getRow(
                    getText(
                        '${Strings.employee_info_eid}：${data.employee.eid}'),
                    getText(
                        '${Strings.employee_info_postName}：${data.post.postName}')),
                Divider(),
                getRow(
                    getText(
                        '${Strings.employee_info_name}：${data.employee.name}'),
                    getText(
                        '${Strings.employee_info_dept}：${data.dept.departmentName}')),
                Divider(),
                getRow(
                    getText(
                        '${Strings.employee_info_lid}：${data.postLevel.lid}'),
                    getText(
                        '${Strings.employee_info_hometown}：${data.employee.hometown}')),
                Divider(),
                getRow(
                    getText('${Strings.employee_info_education}：$education'),
                    getText(
                        '${Strings.employee_info_phone}：${data.employee.phone}')),
                Divider(),
                getRow(
                    getText('${Strings.employee_info_status}：$status'),
                    getText(
                        '${Strings.employee_info_birthday}：${data.employee.birthday}')),
                Divider(),
                getText(
                    '${Strings.employee_info_email}：${data.employee.email}'),
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
