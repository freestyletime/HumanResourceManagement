import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/BaseModel.dart';
import 'package:flutter_hrms/models/IModel.dart';
import 'package:flutter_hrms/models/Salary.dart';
import 'package:flutter_hrms/models/SalaryBean.dart';
import 'package:flutter_hrms/models/SalaryEmployeeBean.dart';
import 'package:flutter_hrms/pages/BasePage.dart';
import 'package:flutter_hrms/widgets/DetailHeaderView.dart';
import 'package:flutter_hrms/widgets/SalaryListView.dart';
import 'package:flutter_hrms/widgets/SearchBox.dart';

class SalaryDetailPage extends StatefulWidget {
  final SalaryEmployeeBean bean;

  const SalaryDetailPage(this.bean);

  @override
  _SalaryDetailState createState() => _SalaryDetailState();
}

class _SalaryDetailState extends BasePageState<SalaryDetailPage> {
  var _source = SalaryBean();
  var _data = ValueNotifier<SalaryBean>(null);
  var _searchKey;

  void _getData() {
    SalaryEmployeeBean data = widget.bean;
    service.getSalaryAPI().getAllSalary(
        Ids.ID_GET_ALL_SALARY + hashCode.toString(),
        data.employee.eid,
        data.lid);
  }

  void _searchCallback(String result) {
    _searchKey = result;
    if (result == null || result.isEmpty) {
      _data.value = _source;
    } else {
      var tmp = SalaryBean();
      tmp.salarys = List<Salary>();
      tmp.salaryLevel = _source.salaryLevel;
      for (var i = 0; i < _source.salarys.length; i++) {
        var bean = _source.salarys[i];
        if (bean.date.substring(0, 7).contains(result)) {
          tmp.salarys.add(bean);
        }
      }
      _data.value = tmp;
    }
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
      title: Text(Strings.salary_list),
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
    return ValueListenableBuilder<SalaryBean>(
        valueListenable: _data,
        builder: (context, data, _) {
          var header = DetailHeaderView(
              id: widget.bean.employee.eid.toString(),
              name: widget.bean.employee.name,
              other: (data == null || data.salarys == null
                      ? '0'
                      : data.salarys.length.toString()) +
                  ' ' +
                  Strings.salary_info_month_total);

          var search = SearchBox(
              content: _searchKey,
              hint: Strings.salary_search_hint,
              callback: _searchCallback);

          if (data == null) {
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
              SalaryListView(data.salaryLevel, data.salarys, isListView: false)
            ]);
          }
        });
  }

  @override
  void success<E extends IModel>(String id, E t) {
    if (Ids.ID_GET_ALL_SALARY + hashCode.toString() == id &&
        t is BaseModel<SalaryBean>) {
      if (Constants.STATUS_SUCCESS == t.status) {
        _searchKey = null;
        if (t.data != null && t.data.length > 0) {
          _source = t.data[0];
          _data.value = t.data[0];
        } else {
          _source = null;
          _data.value = null;
        }
      }
    }
  }
}
