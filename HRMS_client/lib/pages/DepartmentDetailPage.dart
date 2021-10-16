import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/BaseModel.dart';
import 'package:flutter_hrms/models/DepartmentBean.dart';
import 'package:flutter_hrms/models/IModel.dart';
import 'package:flutter_hrms/pages/BasePage.dart';
import 'package:flutter_hrms/pages/CallbackController/CallbackController.dart';
import 'package:flutter_hrms/pages/DepartmentChangePage.dart';
import 'package:flutter_hrms/widgets/DetailHeaderView.dart';
import 'package:flutter_hrms/widgets/Dialog.dart';
import 'package:flutter_hrms/widgets/EmployeeListView.dart';

class DepartmentDetailPage extends StatefulWidget {
  final DepartmentBean bean;

  const DepartmentDetailPage(this.bean);

  @override
  _DepartmentDetailPageState createState() => _DepartmentDetailPageState();
}

class _DepartmentDetailPageState extends BasePageState<DepartmentDetailPage> {
  static const String MENU_CHANGE = 'A';
  static const String MENU_DEL = 'B';
  static const String MENU_RECOVERY = 'C';

  var _controller;
  var _data = ValueNotifier<DepartmentBean>(null);

  void _getData() {
    service.getDepartmentAPI().getDepartment(
        Ids.ID_GET_DEPARTMENT + hashCode.toString(), widget.bean.dept.did);
  }

  void _quit() {
    service.getDepartmentAPI().quitDepartment(
        Ids.ID_QUIT_DEPARTMENT + hashCode.toString(), widget.bean.dept.did);
  }

  void _recovery() {
    service.getDepartmentAPI().recoveryDepartment(
        Ids.ID_RECOVERY_DEPARTMENT + hashCode.toString(), widget.bean.dept.did);
  }

  void _result(String val) {
    if (val != null) {
      showSnackBar(val);
      _getData();
    }
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

  @override
  void initState() {
    _controller = CallbackController(context);
    _data.value = widget.bean;
    super.initState();
  }

  @override
  AppBar getAppBar() {
    var menus = List<Widget>();
    menus.add(IconButton(
        icon: Icon(Icons.refresh),
        onPressed: (() {
          if (!isLoading.value) _getData();
        })));

    if (widget.bean.pdept != null) {
      var pops = List<PopupMenuItem<String>>();
      if (Constants.WORK_WORK == widget.bean.dept.status) {
        pops.add(_getPopup(Icons.track_changes, Strings.department_change, MENU_CHANGE));
        pops.add(_getPopup(Icons.delete_forever, Strings.department_del, MENU_DEL));
      } else {
        pops.add(_getPopup(Icons.restore_from_trash,Strings.department_recovery, MENU_RECOVERY));
      }

      menus.add(PopupMenuButton<String>(
          icon: Icon(Icons.menu),
          itemBuilder: (BuildContext context) => pops,
          onSelected: (String action) {
            switch (action) {
              case MENU_CHANGE:
                Navigator.push<String>(
                  context,
                  MaterialPageRoute(builder: (context) => DepartmentChangePage(widget.bean)),
                ).then(_result);
                break;
              case MENU_DEL:
                 DialogUtils.alert(context,
                        text: Strings.department_quit_hint, yesCallBack: _quit);
                break;
              case MENU_RECOVERY:
                DialogUtils.alert(context,
                        text: Strings.department_recovery_hint,
                        yesCallBack: _recovery);
                break;
            }
          }));
    }

    return AppBar(
      centerTitle: true,
      title: Text(Strings.department_detail),
      actions: menus,
    );
  }

  @override
  Widget getBody() {
    Widget _getDetailElement(DepartmentBean data) {
      var header = DetailHeaderView(
          id: data.dept.did.toString(),
          name: data.dept.departmentName,
          other: (Strings.department_member +
              '：' +
              (data.employees == null ? '0人' : '${data.employees.length}人')));

      if (data.employees == null || data.employees.length == 0) {
        var empty = Text(Strings.msg_data_empty,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[header, Expanded(child: Center(child: empty))],
        );
      }

      return CustomScrollView(physics: ScrollPhysics(), slivers: <Widget>[
        SliverToBoxAdapter(child: header),
        EmployeeListView(data.employees,
            callback: _controller.itemClick, isListView: false)
      ]);
    }

    return ValueListenableBuilder<DepartmentBean>(
        valueListenable: _data,
        builder: (context, data, _) {
          return _getDetailElement(data);
        });
  }

  @override
  void success<E extends IModel>(String id, E t) {
    if (Ids.ID_GET_DEPARTMENT + hashCode.toString() == id &&
        t is BaseModel<DepartmentBean>) {
      if (Constants.STATUS_SUCCESS == t.status) {
        if (t.data != null && t.data.length != 0) {
          _data.value = t.data[0];
        }
      }
    } else if (Ids.ID_QUIT_DEPARTMENT + hashCode.toString() == id &&
        t is IModel) {
      if (Constants.STATUS_SUCCESS == t.status) {
        Navigator.pop<String>(context, Strings.department_quit_success);
      }
    } else if (Ids.ID_RECOVERY_DEPARTMENT + hashCode.toString() == id &&
        t is IModel) {
      if (Constants.STATUS_SUCCESS == t.status) {
        Navigator.pop<String>(context, Strings.department_recovery_success);
      }
    }
  }
}
