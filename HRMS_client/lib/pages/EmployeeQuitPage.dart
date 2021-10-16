import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/BaseModel.dart';
import 'package:flutter_hrms/models/EmployeeBean.dart';
import 'package:flutter_hrms/models/IModel.dart';
import 'package:flutter_hrms/pages/BasePage.dart';
import 'package:flutter_hrms/widgets/EmployeeListView.dart';
import 'package:flutter_hrms/widgets/SearchBox.dart';

import 'CallbackController/CallbackController.dart';

class EmployeeQuitPage extends StatefulWidget {
  static final String tag = 'employee-quit-page';
  @override
  _EmployeeQuitPageState createState() => _EmployeeQuitPageState();
}

class _EmployeeQuitPageState extends BasePageState<EmployeeQuitPage> {
  // 搜索结果记录
  var _searchKey;
  // 统一的回调控制器
  var _controller;
  // 请求原始数据
  var _source = List<EmployeeBean>();
  // 控件持有员工数据
  var _data = ValueNotifier<List<EmployeeBean>>(List());

  void _getData() {
    service
        .getEmployeeAPI()
        .getAllQuitEmployee(Ids.ID_GET_ALL_QUIT_EMPLOYEE + hashCode.toString());
  }

  void _result(String val) {
    if (val != null) {
      showSnackBar(val);
      _getData();
    }
  }

  void _searchCallback(String result) {
    _searchKey = result;
    if (result == null || result.isEmpty) {
      _data.value = _source;
    } else {
      var tmp = List<EmployeeBean>();
      for (var i = 0; i < _source.length; i++) {
        var bean = _source[i];
        // 过滤姓名
        if (bean.employee.name.contains(result)) {
          tmp.add(bean);
          continue;
        }
        // 过滤部门名称
        if (bean.dept.departmentName.contains(result)) {
          tmp.add(bean);
        }
      }
      _data.value = tmp;
    }
  }

  @override
  void initState() {
    _controller = CallbackController(context, result: _result);
    super.initState();
    _getData();
  }

  @override
  AppBar getAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(Strings.employee_menu_list_quit),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.refresh),
            onPressed: (() {
              if (!isLoading.value) _getData();
            }))
      ],
    );
  }

  @override
  Widget getBody() {
    return ValueListenableBuilder<List<EmployeeBean>>(
        valueListenable: _data,
        builder: (context, data, _) {
          var search = SearchBox(
              content: _searchKey,
              hint: Strings.employee_search_hint,
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
              EmployeeListView(data,
                  callback: _controller.itemClick, isListView: false)
            ]);
          }
        });
  }

  @override
  void success<E extends IModel>(String id, E t) {
    if (Ids.ID_GET_ALL_QUIT_EMPLOYEE + hashCode.toString() == id &&
        t is BaseModel<EmployeeBean>) {
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
