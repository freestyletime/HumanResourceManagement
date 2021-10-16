import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/DepartmentBean.dart';
import 'package:flutter_hrms/models/EmployeeBean.dart';
import 'package:flutter_hrms/models/IBean.dart';
import 'package:flutter_hrms/models/local/DataTree.dart';
import 'package:tree_view/tree_view.dart';

class DepartmentTreeListView extends StatelessWidget {
  final Function callback;
  final List<DepartmentBean> _data;

  DepartmentTreeListView(this._data, {this.callback});

  void _onItemClick(IBean data) {
    if (callback != null) {
      callback(data);
    }
  }

  Widget _getRow(Widget left, {Widget right}) {
    if (right == null)
      return Container(
        padding: EdgeInsets.all(5.0),
        child: left,
      );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.all(5.0),
            child: left,
          ),
          flex: 1,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(5.0),
            child: right,
          ),
          flex: 1,
        )
      ],
    );
  }

  DataTree<DepartmentBean> _getNode(DataTree<DepartmentBean> node) {
    if (_data.length > 0) {
      for (var i = 0; i < _data.length; i++) {
        if (_data[i].pdept != null &&
            _data[i].pdept.did == node.parent.dept.did) {
          var child = _getNode(DataTree<DepartmentBean>(0, _data[i]));
          if (child != null) node.children.add(child);
        }
      }
      return node;
    }
  }

  DataTree<DepartmentBean> _getTree() {
    if (_data.length > 0) {
      for (var i = 0; i < _data.length; i++) {
        if (_data[i].pdept == null && _data[i].dept.did == 1) {
          return _getNode(DataTree<DepartmentBean>(0, _data[i]));
        }
      }
    }
  }

  Widget _getText(String str) {
    return Text(str, style: TextStyle(fontSize: 15));
  }

  Widget _getNodeView(double margin, EmployeeBean bean) {
    return Container(
        margin: EdgeInsets.only(left: margin),
        child: Card(
          color: bean.employee.gender == Constants.GENDER_MALE
              ? Colors.grey
              : Colors.pinkAccent,
          elevation: 5.0,
          child: ListTile(
            leading: Image.asset(bean.employee.gender == Constants.GENDER_MALE
                ? 'assets/images/man.png'
                : 'assets/images/woman.png'),
            title: _getText('#${bean.employee.eid} ${bean.employee.name}'),
            subtitle: _getText('${bean.postLevel.lid}-${bean.post.postName}'),
            trailing: IconButton(
              icon: Icon(Icons.navigate_next),
              onPressed: () {
                _onItemClick(bean);
              },
            ),
          ),
        ));
  }

  Widget _getTreeView(double margin, DataTree<DepartmentBean> tree) {
    var view = Container(
        margin: EdgeInsets.only(left: margin),
        child: Card(
          color: Colors.blueGrey,
          elevation: 5.0,
          child: ListTile(
            leading: Image.asset('assets/images/department.png'),
            title: _getText(
                '#${tree.parent.dept.did} ${tree.parent.dept.departmentName}'),
            subtitle: _getText(Strings.department_member +
                (tree.parent.employees == null
                    ? '0人'
                    : '${tree.parent.employees.length}人')),
            trailing: IconButton(
              icon: Icon(Icons.navigate_next),
              onPressed: () {
                _onItemClick(tree.parent);
              },
            ),
          ),
        ));

    var children = List<Widget>();
    // 添加部门下部门
    if (tree.children != null && tree.children.length > 0) {
      children.addAll(tree.children.map((node) {
        return _getTreeView(margin + 10, node);
      }).toList());
    }

    // 添加部门下员工
    if (tree.parent.employees != null && tree.parent.employees.length > 0) {
      children.addAll(tree.parent.employees.map((node) {
        return _getNodeView(margin + 10, node);
      }).toList());
    }

    return Parent(parent: view, childList: ChildList(children: children));
  }

  Widget _getTreeWidget() {
    var list = List<Parent>();
    double margin = 0;
    DataTree<DepartmentBean> _tree = _getTree();
    if (_tree != null) list.add(_getTreeView(margin, _tree));
    return TreeView(parentList: list);
  }

  @override
  Widget build(BuildContext context) {
    return _getTreeWidget();
  }
}