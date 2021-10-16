import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/BaseModel.dart';
import 'package:flutter_hrms/models/IModel.dart';
import 'package:flutter_hrms/models/SalaryEmployeeBean.dart';
import 'package:flutter_hrms/pages/BasePage.dart';
import 'package:flutter_hrms/pages/CallbackController/CallbackController.dart';
import 'package:flutter_hrms/widgets/SalaryEmployeeListView.dart';
import 'package:flutter_hrms/widgets/SearchBox.dart';

class SalaryPage extends StatefulWidget {
  static final String tag = 'salary-page';
  @override
  _SalaryPageState createState() => _SalaryPageState();
}

class _SalaryPageState extends BasePageState<SalaryPage> {
  var _controller;
  var _source = List<SalaryEmployeeBean>();
  var _data = ValueNotifier<List<SalaryEmployeeBean>>(List());
  var _searchKey;

  void _getData() {
    service
        .getSalaryAPI()
        .getAllSalaryEmployee(Ids.ID_GET_ALL_SALARY_EMP + hashCode.toString());
  }

  void _searchCallback(String result) {
    _searchKey = result;
    if (result == null || result.isEmpty) {
      _data.value = _source;
    } else {
      var tmp = List<SalaryEmployeeBean>();
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
      title: Text(Strings.salary),
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
    return ValueListenableBuilder<List<SalaryEmployeeBean>>(
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
              SalaryEmployeeListView(data, callback: _controller.itemClick, isListView: false)
            ]);
          }
        });
  }

  @override
  void success<E extends IModel>(String id, E t) {
    if (Ids.ID_GET_ALL_SALARY_EMP + hashCode.toString() == id &&
        t is BaseModel<SalaryEmployeeBean>) {
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
