import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/DepartmentBean.dart';

class DepartmentListView extends StatelessWidget {
  final List<DepartmentBean> data;
  final Function callback;
  final bool isListView;

  DepartmentListView(this.data, {this.callback, this.isListView = true});

  void _onItemClick(DepartmentBean data) {
    if (callback != null) {
      callback(data);
    }
  }

  Widget _renderRow(int position, List<DepartmentBean> datas) {
    if (position.isOdd) return Divider();

    final index = position ~/ 2;
    DepartmentBean data = datas[index];
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
                    getText('${Strings.department_info_did}：${data.dept.did}'),
                    getText('${Strings.department_member}' +
                        (data.employees == null
                            ? '0人'
                            : '${data.employees.length}人'))),
                Divider(),
                getText('${Strings.department_info_name}：${data.dept.departmentName}'),
                Divider(),
                getText('${Strings.department_info_pdept}：' +
                    (data.pdept == null ? '' : data.pdept.departmentName))
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
