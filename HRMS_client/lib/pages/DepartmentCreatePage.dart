import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/Department.dart';
import 'package:flutter_hrms/models/IModel.dart';
import 'package:flutter_hrms/pages/BasePage.dart';

import 'DepartmentPage.dart';

class DepartmentCreatePage extends StatefulWidget {
  @override
  _DepartmentCreatePageState createState() => _DepartmentCreatePageState();
}

class _DepartmentCreatePageState extends BasePageState<DepartmentCreatePage> {
  // 统一风格
  var style = TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0);
  // 部门名称
  String _name;
  // 部门描述
  String _description = '';
  // 父部门
  var _pdept = ValueNotifier<Department>(null);

  void _submit() {
    if (_name == null || _pdept.value == null) {
      showSnackBar(Strings.msg_key_empty);
      return;
    }

    service.getDepartmentAPI().addDepartment(
          Ids.ID_ADD_DEPARTMENT + hashCode.toString(),
          _name,
          _pdept.value.did,
          _description,
        );
  }

  Widget _getOrdinaryInputWidget(int maxLength, String content, String label,
      String hint, Function result) {
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
        title: Text(Strings.department_menu_add),
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
    var gap = SizedBox(height: 10);

    var nameWidget = _getOrdinaryInputWidget(
      50,
      _name,
      Strings.department_info_name,
      Strings.department_info_name_hint,
      (val) => val.isEmpty ? _name = '' : _name = val,
    );

    var descriptionWidget = _getOrdinaryInputWidget(
      100,
      _description,
      Strings.department_info_description,
      Strings.department_info_description_hint,
      (val) => val.isEmpty ? _description = '' : _description = val,
    );

    var pdeptWidget = ValueListenableBuilder<Department>(
        valueListenable: _pdept,
        builder: (context, dept, _) {
          return TextField(
              enableInteractiveSelection: false,
              controller: TextEditingController(
                  text: dept == null
                      ? ''
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
                    _pdept.value = dept;
                  }
                });
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              decoration: InputDecoration(
                labelStyle: style,
                labelText: dept == null
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
    if (Ids.ID_ADD_DEPARTMENT + hashCode.toString() == id && t is IModel) {
      if (Constants.STATUS_SUCCESS == t.status) {
        Navigator.pop<String>(context, Strings.department_add_success);
      }
    }
  }
}
