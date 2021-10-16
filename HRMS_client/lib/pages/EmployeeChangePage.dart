import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/Department.dart';
import 'package:flutter_hrms/models/Employee.dart';
import 'package:flutter_hrms/models/EmployeeBean.dart';
import 'package:flutter_hrms/models/IModel.dart';
import 'package:flutter_hrms/models/Post.dart';
import 'package:flutter_hrms/pages/BasePage.dart';
import 'package:flutter_hrms/widgets/DetailHeaderView.dart';

import 'DepartmentPage.dart';
import 'EmployeePage.dart';
import 'PostPage.dart';

class EmployeeChangePage extends StatefulWidget {
  final EmployeeBean bean;

  EmployeeChangePage(this.bean);

  @override
  _EmployeeChangePageState createState() => _EmployeeChangePageState();
}

class _EmployeeChangePageState extends BasePageState<EmployeeChangePage> {
  // 工资
  String _salary;
  // 职位
  var _post = ValueNotifier<Post>(null);
  // 部门
  var _dept = ValueNotifier<Department>(null);
  // 上级
  var _employee = ValueNotifier<Employee>(null);

  void _submit() {
    var data = widget.bean;
    if (_salary == null &&
        _post.value == null &&
        _dept.value == null &&
        _employee.value == null) {
      showSnackBar(Strings.msg_key_old);
      return;
    }

    service.getEmployeeAPI().changeEmployee(
        Ids.ID_CHANGE_EMPLOYEE + hashCode.toString(),
        data.employee.eid,
        _salary == null ? data.employee.salary.toString() : _salary,
        _post.value == null ? data.post.pid : _post.value.pid,
        _dept.value == null ? data.dept.did : _dept.value.did,
        _employee.value == null ? data.leader.eid : _employee.value.eid);
  }

  @override
  AppBar getAppBar() {
    return AppBar(
        centerTitle: true,
        title: Text(Strings.employee_change),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.done_all),
              onPressed: (() {
                if (!isLoading.value) _submit();
              })),
        ]);
  }

  @override
  Widget getBody() {
    var data = widget.bean;
    // 统一风格
    var style = TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0);
    var gap = SizedBox(height: 10);
    var header = DetailHeaderView(
        id: data.employee.eid.toString(),
        name: data.employee.name,
        other: data.employee.email);

    var salaryWidget = TextField(
        maxLength: 7,
        keyboardType: TextInputType.number,
        controller: TextEditingController(
            text: _salary == null ? data.employee.salary.toString() : _salary),
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelStyle: style,
          hintText: Strings.employee_info_salary_hint,
          labelText: Strings.employee_info_salary,
        ),
        onChanged: (val) => val.isEmpty ? _salary = '' : _salary = val);

    var postWidget = ValueListenableBuilder<Post>(
        valueListenable: _post,
        builder: (context, post, _) {
          return TextField(
              enableInteractiveSelection: false,
              controller: TextEditingController(
                  text: post == null
                      ? ('#' +
                          data.post.pid.toString() +
                          ' ' +
                          data.post.postName)
                      : ('#' + post.pid.toString() + ' ' + post.postName)),
              onTap: () {
                Navigator.push<Post>(
                  context,
                  MaterialPageRoute<Post>(
                      builder: (context) => PostPage(isSelect: true)),
                ).then((Post post) {
                  if (post == null) {
                    showSnackBar(Strings.msg_select_empty);
                  } else {
                    if (post.pid == data.post.pid) {
                      showSnackBar(Strings.msg_select_same);
                    } else {
                      _post.value = post;
                    }
                  }
                });
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              decoration: InputDecoration(
                labelStyle: style,
                labelText: post == null
                    ? Strings.employee_info_postName_hint
                    : Strings.employee_info_postName,
              ));
        });

    var deptWidget = ValueListenableBuilder<Department>(
        valueListenable: _dept,
        builder: (context, dept, _) {
          return TextField(
              enableInteractiveSelection: false,
              controller: TextEditingController(
                  text: dept == null
                      ? ('#' +
                          data.dept.did.toString() +
                          ' ' +
                          data.dept.departmentName)
                      : ('#' +
                          dept.did.toString() +
                          ' ' +
                          dept.departmentName)),
              onTap: () {
                Navigator.push<Department>(
                  context,
                  MaterialPageRoute<Department>(
                      builder: (context) => DepartmentPage(isSelect: true)),
                ).then((Department dept) {
                  if (dept == null) {
                    showSnackBar(Strings.msg_select_empty);
                  } else {
                    if (dept.did == data.dept.did) {
                      showSnackBar(Strings.msg_select_same);
                    } else {
                      _dept.value = dept;
                    }
                  }
                });
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              decoration: InputDecoration(
                labelStyle: style,
                labelText: dept == null
                    ? Strings.employee_info_dept_hint
                    : Strings.employee_info_dept,
              ));
        });

    var employeeWidget = ValueListenableBuilder<Employee>(
        valueListenable: _employee,
        builder: (context, employee, _) {
          return TextField(
              enableInteractiveSelection: false,
              controller: TextEditingController(
                  text: employee == null
                      ? ('#' +
                          data.leader.eid.toString() +
                          ' ' +
                          data.leader.name)
                      : ('#' + employee.eid.toString() + ' ' + employee.name)),
              onTap: () {
                Navigator.push<Employee>(
                  context,
                  MaterialPageRoute<Employee>(
                      builder: (context) => EmployeePage(isSelect: true)),
                ).then((Employee emp) {
                  if (emp == null) {
                    showSnackBar(Strings.msg_select_empty);
                  } else {
                    if (emp.eid == data.employee.eid ||
                        emp.eid == data.leader.eid) {
                      showSnackBar(Strings.msg_select_same);
                    } else {
                      _employee.value = emp;
                    }
                  }
                });
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              decoration: InputDecoration(
                labelStyle: style,
                labelText: employee == null
                    ? Strings.employee_info_leader_hint
                    : Strings.employee_info_leader,
              ));
        });

    return ListView(
      children: <Widget>[
        header,
        Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(children: <Widget>[
              salaryWidget,
              gap,
              postWidget,
              gap,
              deptWidget,
              gap,
              employeeWidget,
            ]))
      ],
    );
  }

  @override
  void success<E extends IModel>(String id, E t) {
    if (Ids.ID_CHANGE_EMPLOYEE + hashCode.toString() == id && t is IModel) {
      if (Constants.STATUS_SUCCESS == t.status) {
        Navigator.pop<String>(context, Strings.employee_change_success);
      }
    }
  }
}
