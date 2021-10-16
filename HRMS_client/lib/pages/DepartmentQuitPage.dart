import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/BaseModel.dart';
import 'package:flutter_hrms/models/DepartmentBean.dart';
import 'package:flutter_hrms/models/IModel.dart';
import 'package:flutter_hrms/pages/BasePage.dart';
import 'package:flutter_hrms/widgets/DepartmentListView.dart';
import 'package:flutter_hrms/widgets/SearchBox.dart';

import 'CallbackController/CallbackController.dart';

class DepartmentQuitPage extends StatefulWidget {
   static final String tag = 'department-quit-page';
  @override
  _DepartmentQuitPageState createState() => _DepartmentQuitPageState();
}

class _DepartmentQuitPageState extends BasePageState<DepartmentQuitPage> {
  var _controller;
  var _source = List<DepartmentBean>();
  var _data = ValueNotifier<List<DepartmentBean>>(List());
  var _searchKey;

  void _getData() {
    service.getDepartmentAPI().getAllQuitDepartment(
        Ids.ID_GET_ALL_QUIT_DEPARTMENT + hashCode.toString());
  }

  void _searchCallback(String result) {
    _searchKey = result;
    if (result == null || result.isEmpty) {
      _data.value = _source;
    } else {
      var tmp = List<DepartmentBean>();
      for (var i = 0; i < _source.length; i++) {
        var bean = _source[i];
        if (bean.dept.departmentName.contains(result)) {
          tmp.add(bean);
        }
      }
      _data.value = tmp;
    }
  }

  void _result(String val) {
    if (val != null) {
      showSnackBar(val);
      _getData();
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
      title: Text(Strings.department_menu_del_list),
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
    return ValueListenableBuilder<List<DepartmentBean>>(
        valueListenable: _data,
        builder: (context, data, _) {
          var search = SearchBox(
              content: _searchKey,
              hint: Strings.department_search_hint,
              callback: _searchCallback);

          if (data.length == 0) {
            var empty = Text(Strings.msg_data_empty,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[search, Expanded(child: Center(child: empty))],
            );
          }

          return CustomScrollView(physics: ScrollPhysics(), slivers: <Widget>[
            SliverToBoxAdapter(child: search),
            DepartmentListView(data,
                callback: _controller.itemClick, isListView: false)
          ]);
        });
  }

  @override
  void success<E extends IModel>(String id, E t) {
    if (Ids.ID_GET_ALL_QUIT_DEPARTMENT + hashCode.toString() == id &&
        t is BaseModel<DepartmentBean>) {
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
