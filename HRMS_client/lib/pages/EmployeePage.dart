import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/BaseModel.dart';
import 'package:flutter_hrms/models/EmployeeBean.dart';
import 'package:flutter_hrms/models/IModel.dart';
import 'package:flutter_hrms/pages/BasePage.dart';
import 'package:flutter_hrms/pages/CallbackController/CallbackController.dart';
import 'package:flutter_hrms/widgets/EmployeeListView.dart';
import 'package:flutter_hrms/widgets/EmployeeTableData.dart';
import 'package:flutter_hrms/widgets/EmployeeTreeListView.dart';
import 'package:flutter_hrms/widgets/SearchBox.dart';

import 'EmployeeCreatePage.dart';
import 'EmployeeQuitPage.dart';

class EmployeePage extends StatefulWidget {
  static final String tag = 'employee-page';
  final bool isSelect;

  const EmployeePage({Key key, this.isSelect = false}) : super(key: key);

  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends BasePageState<EmployeePage> {
  static const int MODEL_LIST = 0;
  static const int MODEL_TABLE = 1;
  static const int MODEL_TREE = 2;

  static const String MENU_LIST = 'A';
  static const String MENU_TABLE = 'B';
  static const String MENU_ADD = 'C';
  static const String MENU_TREE = 'D';
  static const String MENU_LIST_QUIT = 'E';

  // 统一的回调控制器
  var _controller;
  // 请求原始数据
  var _source = List<EmployeeBean>();
  // 控件持有员工数据
  var _data = ValueNotifier<List<EmployeeBean>>(List());

  // 当前模式 0-列表 ，1-datatable，2-tree
  var _model = MODEL_LIST;
  // 上一次的菜单点击状态
  var _menu = MENU_LIST;
  // 搜索结果记录
  var _searchKey;

  void _getData() {
    service
        .getEmployeeAPI()
        .getAllEmployee(Ids.ID_GET_ALL_EMPLOYEE + hashCode.toString());
  }

  Widget _getPopup(IconData icon, String text, String id) {
    return new PopupMenuItem<String>(
        value: id,
        child: Row(
          children: <Widget>[
            Icon(icon, color: Colors.blueGrey),
            SizedBox(width: 5),
            Text(text),
          ],
        ));
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
    _controller =
        CallbackController(context, isSelect: widget.isSelect, result: _result);
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  AppBar getAppBar() {
    var menus = List<Widget>();
    if (!widget.isSelect) {
      menus.add(IconButton(
          icon: Icon(Icons.refresh),
          onPressed: (() {
            if (!isLoading.value) _getData();
          })));
      menus.add(PopupMenuButton<String>(
        icon: Icon(Icons.menu),
        itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
          _getPopup(Icons.person_add, Strings.employee_menu_add, MENU_ADD),
          _getPopup(Icons.list, Strings.employee_menu_list_quit, MENU_LIST_QUIT),
          _getPopup(Icons.format_list_numbered, Strings.employee_menu_list, MENU_LIST),
          _getPopup( Icons.insert_chart, Strings.employee_menu_table, MENU_TABLE),
          _getPopup(Icons.sort, Strings.employee_menu_tree, MENU_TREE)
        ],
        onSelected: (String action) {
          if (_menu == action && MENU_ADD != action && MENU_LIST_QUIT != action)
            return;
          _menu = action;

          switch (action) {
            case MENU_LIST:
              setState(() {
                _model = MODEL_LIST;
              });
              break;
            case MENU_TABLE:
              setState(() {
                _model = MODEL_TABLE;
              });
              break;
            case MENU_TREE:
              setState(() {
                _model = MODEL_TREE;
              });
              break;
            case MENU_ADD:
              Navigator.push<String>(
                context,
                MaterialPageRoute<String>(
                    builder: (context) => EmployeeCreatePage()),
              ).then(_result);
              break;
            case MENU_LIST_QUIT:
              Navigator.of(context).pushNamed(EmployeeQuitPage.tag);
              break;
          }
        },
      ));
    }

    return AppBar(
      centerTitle: true,
      title: Text(Strings.employee),
      actions: menus,
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
            if (MODEL_LIST == _model)
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  search,
                  Expanded(child: Center(child: empty))
                ],
              );
            return Center(child: empty);
          } else {
            if (MODEL_LIST == _model) {
              //return EmployeeListView(data, callback: _controller.callback);
              return CustomScrollView(
                  physics: ScrollPhysics(),
                  slivers: <Widget>[
                    SliverToBoxAdapter(child: search),
                    EmployeeListView(data,
                        callback: _controller.itemClick, isListView: false)
                  ]);
            } else if (MODEL_TREE == _model) {
              return EmployeeTreeListView(data,
                  callback: _controller.itemClick);
            } else
              return EmployeeTableData(data);
          }
        });
  }

  @override
  void success<E extends IModel>(String id, E t) {
    if (Ids.ID_GET_ALL_EMPLOYEE + hashCode.toString() == id &&
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
