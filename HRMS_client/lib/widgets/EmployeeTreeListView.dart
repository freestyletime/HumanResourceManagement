import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/EmployeeBean.dart';
import 'package:flutter_hrms/models/local/DataTree.dart';
import 'package:tree_view/tree_view.dart';

class EmployeeTreeListView extends StatelessWidget {
  final List<EmployeeBean> _data;
  final Function callback;

  EmployeeTreeListView(this._data, {this.callback});

  void _onItemClick(EmployeeBean data) {
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

  DataTree<EmployeeBean> _getNode(DataTree<EmployeeBean> node) {
    if (_data.length > 0) {
      for (var i = 0; i < _data.length; i++) {
        if (_data[i].leader != null &&
            _data[i].leader.eid == node.parent.employee.eid) {
          var child = _getNode(DataTree<EmployeeBean>(0, _data[i]));
          if (child != null) node.children.add(child);
        }
      }
      return node;
    }
  }

  DataTree<EmployeeBean> _getTree() {
    // 寻找根结点 判断条件 上级员工不存在 and 上级部门不存在
    if (_data.length > 0) {
      for (var i = 0; i < _data.length; i++) {
        if (_data[i].leader == null && _data[i].pdept == null) {
          return _getNode(DataTree<EmployeeBean>(0, _data[i]));
        }
      }
    }
  }

  Widget _getText(String str) {
    return Text(str, style: TextStyle(fontSize: 15));
  }

  Widget _getTreeView(double margin, DataTree<EmployeeBean> tree) {
    var view = Container(
        margin: EdgeInsets.only(left: margin),
        child: Card(
          color: tree.parent.employee.gender == Constants.GENDER_MALE
              ? Colors.grey
              : Colors.pinkAccent,
          elevation: 5.0,
          child: ListTile(
            leading: Image.asset(
                tree.parent.employee.gender == Constants.GENDER_MALE
                    ? 'assets/images/man.png'
                    : 'assets/images/woman.png'),
            title: _getText(
                '#${tree.parent.employee.eid} ${tree.parent.employee.name}'),
            subtitle: _getText(
                '${tree.parent.postLevel.lid}-${tree.parent.post.postName}'),
            trailing: IconButton(
              icon: Icon(Icons.navigate_next),
              onPressed: () {
                _onItemClick(tree.parent);
              },
            ),
          ),
        ));

    return Parent(
        parent: view,
        childList: ChildList(
            children: tree.children.map((tree) {
          return _getTreeView(margin + 10, tree);
        }).toList()));
  }

  Widget _getTreeWidget() {
    var list = List<Parent>();
    double margin = 0;
    DataTree<EmployeeBean> _tree = _getTree();
    if (_tree != null) list.add(_getTreeView(margin, _tree));
    return TreeView(parentList: list);
  }

  @override
  Widget build(BuildContext context) {
    return _getTreeWidget();
  }
}
