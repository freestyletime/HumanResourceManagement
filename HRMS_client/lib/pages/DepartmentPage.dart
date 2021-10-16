import 'package:flutter/material.dart';
import 'package:flutter_hrms/models/BaseModel.dart';
import 'package:flutter_hrms/models/DepartmentBean.dart';
import 'package:flutter_hrms/models/IModel.dart';
import 'package:flutter_hrms/pages/BasePage.dart';
import 'package:flutter_hrms/pages/DepartmentCreatePage.dart';
import 'package:flutter_hrms/widgets/DepartmentListView.dart';
import 'package:flutter_hrms/widgets/DepartmentTreeListView.dart';
import 'package:flutter_hrms/widgets/SearchBox.dart';

import '../Constants.dart';
import 'CallbackController/CallbackController.dart';
import 'DepartmentQuitPage.dart';

// 部门管理页/部门选择页
class DepartmentPage extends StatefulWidget {
  static final String tag = 'department-page';
  final bool isSelect;

  const DepartmentPage({Key key, this.isSelect = false}) : super(key: key);
  @override
  _DepartmentPageState createState() => _DepartmentPageState();
}

class _DepartmentPageState extends BasePageState<DepartmentPage> {
  static const int MODEL_LIST = 0;
  static const int MODEL_TREE = 1;

  static const String MENU_ADD = 'A';
  static const String MENU_LIST = 'B';
  static const String MENU_TREE = 'C';
  static const String MENU_LIST_QUIT = 'E';

  var _controller;
  var _source = List<DepartmentBean>();
  var _data = ValueNotifier<List<DepartmentBean>>(List());
  var _model = MODEL_TREE;
  var _searchKey;

  void _getData() {
    service
        .getDepartmentAPI()
        .getAllDepartment(Ids.ID_GET_ALL_DEPARTMENT + hashCode.toString());
  }

  Widget _getPopup(IconData icon, String text, String id) {
    return PopupMenuItem<String>(
        value: id,
        child: Row(
          children: <Widget>[
            Icon(icon, color: Colors.blueGrey),
            SizedBox(width: 5),
            Text(text),
          ],
        ));
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
    if (widget.isSelect) _model = MODEL_LIST;
    _controller =
        CallbackController(context, isSelect: widget.isSelect, result: _result);
    super.initState();
    _getData();
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
          _getPopup(Icons.group_add, Strings.department_menu_add, MENU_ADD),
          _getPopup(Icons.list, Strings.department_menu_del_list, MENU_LIST_QUIT),
          _getPopup(Icons.format_list_numbered, Strings.department_menu_list, MENU_LIST),
          _getPopup(Icons.sort, Strings.department_menu_tree, MENU_TREE),
        ],
        onSelected: (String action) {
          if (_model == action) return;
          switch (action) {
            case MENU_LIST:
              setState(() {
                _model = MODEL_LIST;
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
                    builder: (context) => DepartmentCreatePage()),
              ).then(_result);
              break;
            case MENU_LIST_QUIT:
              Navigator.of(context).pushNamed(DepartmentQuitPage.tag);
              break;
          }
        },
      ));
    }

    return AppBar(
        centerTitle: true, title: Text(Strings.department), actions: menus);
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
          } else if (MODEL_LIST == _model) {
            // return  DepartmentListView(data, callback: _controller.callback);
            return CustomScrollView(physics: ScrollPhysics(), slivers: <Widget>[
              SliverToBoxAdapter(child: search),
              DepartmentListView(data,
                  callback: _controller.itemClick, isListView: false)
            ]);
          }
          return DepartmentTreeListView(data, callback: _controller.itemClick);
        });
  }

  @override
  void success<E extends IModel>(String id, E t) {
    if (Ids.ID_GET_ALL_DEPARTMENT + hashCode.toString() == id &&
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
