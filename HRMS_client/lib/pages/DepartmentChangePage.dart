import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/Department.dart';
import 'package:flutter_hrms/models/DepartmentBean.dart';
import 'package:flutter_hrms/models/IModel.dart';
import 'package:flutter_hrms/pages/BasePage.dart';

import 'DepartmentPage.dart';

class DepartmentChangePage extends StatefulWidget {
  final DepartmentBean bean;

  const DepartmentChangePage(this.bean);
  @override
  _DepartmentChangePageState createState() => _DepartmentChangePageState();
}

class _DepartmentChangePageState extends BasePageState<DepartmentChangePage> {
  // 部门名
  String _name;
  // 个人描述
  String _description = '';
  // 部门
  var _pdept = ValueNotifier<Department>(null);

  void _submit() {
    var data = widget.bean;
    if (_name == null && _pdept.value == null) {
      showSnackBar(Strings.msg_key_old);
      return;
    }

    service.getDepartmentAPI().changeEmployee(
        Ids.ID_CHANGE_DEPARTMENT + hashCode.toString(),
        data.dept.did,
        _name == null ? data.dept.departmentName : _name,
        _pdept.value == null ? data.pdept.did : _pdept.value.did,
        _description.isEmpty
            ? (data.dept.description == null ? '' : data.dept.description)
            : _description);
  }

  Widget _getOrdinaryInputWidget(int maxLength, String content, String label,
      String hint, TextStyle style, Function result) {
    return TextField(
        controller: TextEditingController(text: content),
        maxLength: maxLength,
        decoration: InputDecoration(
          labelStyle: style,
          hintText: hint,
          labelText: label,
        ),
        onChanged: result);
  }

  @override
  AppBar getAppBar() {
    return AppBar(
        centerTitle: true,
        title: Text(Strings.department_change),
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
    var style = TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0);
    var gap = SizedBox(height: 10);

    var nameWidget = _getOrdinaryInputWidget(
      50,
      _name == null ? data.dept.departmentName : _name,
      Strings.department_info_name,
      Strings.department_info_name_hint,
      style,
      (val) => val.isEmpty ? _name = '' : _name = val,
    );

    var descriptionWidget = _getOrdinaryInputWidget(
      100,
      _description.isEmpty
          ? (data.dept.description == null ? '' : data.dept.description)
          : _description,
      Strings.department_info_description,
      Strings.department_info_description_hint,
      style,
      (val) => val.isEmpty ? _description = '' : _description = val,
    );

    var pdeptWidget = ValueListenableBuilder<Department>(
        valueListenable: _pdept,
        builder: (context, pdept, _) {
          return TextField(
              enableInteractiveSelection: false,
              controller: TextEditingController(
                  text: pdept == null
                      ? ('#' +
                          data.pdept.did.toString() +
                          ' ' +
                          data.pdept.departmentName)
                      : ('#' +
                          pdept.did.toString() +
                          ' ' +
                          pdept.departmentName)),
              onTap: () {
                Navigator.push<Department>(
                  context,
                  MaterialPageRoute<Department>(
                      builder: (context) => DepartmentPage(isSelect: true)),
                ).then((Department dept) {
                  if (dept == null) {
                    showSnackBar(Strings.msg_select_empty);
                  } else {
                    //判断是否是同一部门
                    if (dept.did == data.dept.did ||
                        dept.did == data.pdept.did) {
                      showSnackBar(Strings.msg_select_same);
                    } else {
                      _pdept.value = dept;
                    }
                  }
                });
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              decoration: InputDecoration(
                labelStyle: style,
                labelText: pdept == null
                    ? Strings.employee_info_pdept_hint
                    : Strings.employee_info_pdept,
              ));
        });

    return ListView(padding: EdgeInsets.all(15.0), children: <Widget>[
      nameWidget,
      gap,
      descriptionWidget,
      gap,
      pdeptWidget,
    ]);
  }

  @override
  void success<E extends IModel>(String id, E t) {
    // TODO: implement success
  }
}
