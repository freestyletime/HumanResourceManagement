import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/Department.dart';
import 'package:flutter_hrms/models/Employee.dart';
import 'package:flutter_hrms/models/IModel.dart';
import 'package:flutter_hrms/models/Post.dart';
import 'package:flutter_hrms/pages/BasePage.dart';
import 'package:flutter_hrms/pages/DepartmentPage.dart';
import 'package:flutter_hrms/pages/EmployeePage.dart';
import 'package:flutter_hrms/pages/PostPage.dart';

// 新增员工页
class EmployeeCreatePage extends StatefulWidget {
  @override
  _EmployeeCreatePageState createState() => _EmployeeCreatePageState();
}

class _EmployeeCreatePageState extends BasePageState<EmployeeCreatePage> {
  // 统一风格
  var style = TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0);
  // 姓名
  String _name;
  // 生日-年
  String _year;
  // 生日-月
  String _month;
  // 生日-日
  String _day;
  // 毕业院校
  String _school;
  // 毕业院校
  String _hometown;
  // 毕业院校
  String _phone;
  // 工资
  String _salary;
  // 个人描述
  String _description = '';
  // 职位
  var _post = ValueNotifier<Post>(null);
  // 部门
  var _dept = ValueNotifier<Department>(null);
  // 上级
  var _employee = ValueNotifier<Employee>(null);
  // 默认女
  var _gender = ValueNotifier<int>(Constants.GENDER_FEMALE);
  // 默认高中及以下
  var _education = ValueNotifier<int>(Constants.EDUCATION_OTHER);
  // 提交员工入职资料
  void _submit() {
    if (_name == null ||
        _year == null ||
        _month == null ||
        _day == null ||
        _school == null ||
        _hometown == null ||
        _phone == null ||
        _salary == null ||
        _post.value == null ||
        _dept.value == null ||
        _employee.value == null) {
      showSnackBar(Strings.msg_key_empty);
      return;
    }

    var month = int.parse(_month);
    var day = int.parse(_day);
    if (month < 0 || month > 12 || day < 0 || day > 31) {
      showSnackBar(Strings.msg_key_format_error);
      return;
    }

    service.getEmployeeAPI().addEmployee(
        Ids.ID_ADD_EMPLOYEE + hashCode.toString(),
        _name,
        _gender.value,
        _year,
        _month,
        _day,
        _hometown,
        _phone,
        _school,
        _education.value,
        _salary,
        _description,
        _post.value.pid,
        _dept.value.did,
        _employee.value.eid);
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

  Widget _getBirthdayInputWidget(
      int maxLength, String content, String hintText, Function result) {
    return Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 50),
        child: TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: maxLength,
            maxLines: 1,
            controller: TextEditingController(text: content),
            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              counterText: "",
              hintText: hintText,
              contentPadding: EdgeInsets.all(7.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            ),
            onChanged: result));
  }

  @override
  AppBar getAppBar() {
    return AppBar(
        centerTitle: true,
        title: Text(Strings.employee_menu_add),
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
    // 性别数据
    var _genderDatas = <String>[Strings.employee_female, Strings.employee_male]
        .map<DropdownMenuItem<int>>((String val) {
      return DropdownMenuItem<int>(
        value: Strings.employee_female == val
            ? Constants.GENDER_FEMALE
            : Constants.GENDER_MALE,
        child: Text(val),
      );
    }).toList();
    // 学历数据
    var _educationDatas = <String>[
      Strings.employee_education_other,
      Strings.employee_college,
      Strings.employee_bachelor,
      Strings.employee_master,
      Strings.employee_phd
    ].map<DropdownMenuItem<int>>((String val) {
      return DropdownMenuItem<int>(
        value: val == Strings.employee_education_other
            ? Constants.EDUCATION_OTHER
            : val == Strings.employee_college
                ? Constants.EDUCATION_COLLEGE
                : val == Strings.employee_bachelor
                    ? Constants.EDUCATION_BACHELOR
                    : val == Strings.employee_master
                        ? Constants.EDUCATION_MASTER
                        : Constants.EDUCATION_PHD,
        child: Text(val),
      );
    }).toList();

    var nameWidget = _getOrdinaryInputWidget(
      6,
      _name,
      Strings.employee_info_name,
      Strings.employee_info_name_hint,
      (val) => val.isEmpty ? _name = '' : _name = val,
    );

    var schoolWidget = _getOrdinaryInputWidget(
        12,
        _school,
        Strings.employee_info_school,
        Strings.employee_info_school_hint,
        (val) => val.isEmpty ? _school = '' : _school = val);

    var hometownWidget = _getOrdinaryInputWidget(
        10,
        _hometown,
        Strings.employee_info_hometown,
        Strings.employee_info_hometown_hint,
        (val) => val.isEmpty ? _hometown = '' : _hometown = val);

    var descriptionWidget = _getOrdinaryInputWidget(
        100,
        _description,
        Strings.employee_info_description,
        Strings.employee_info_description_hint,
        (val) => val.isEmpty ? _description = '' : _description = val);

    var phoneWidget = TextField(
        maxLength: 11,
        controller: TextEditingController(text: _phone),
        keyboardType: TextInputType.phone,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelStyle: style,
          hintText: Strings.employee_info_phone_hint,
          labelText: Strings.employee_info_phone,
        ),
        onChanged: (val) => val.isEmpty ? _phone = '' : _phone = val);

    var salaryWidget = TextField(
        maxLength: 7,
        keyboardType: TextInputType.number,
        controller: TextEditingController(text: _salary),
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelStyle: style,
          hintText: Strings.employee_info_salary_hint,
          labelText: Strings.employee_info_salary,
        ),
        onChanged: (val) => val.isEmpty ? _salary = '' : _salary = val);

    var yearWidget = _getBirthdayInputWidget(
        4,
        _year,
        Strings.employee_info_birthday_year,
        (val) => val.isEmpty ? _year = '' : _year = val);
    var monthWidget = _getBirthdayInputWidget(
        2,
        _month,
        Strings.employee_info_birthday_month,
        (val) => val.isEmpty ? _month = '' : _month = val);
    var dayWidget = _getBirthdayInputWidget(
        2,
        _day,
        Strings.employee_info_birthday_day,
        (val) => val.isEmpty ? _day = '' : _day = val);

    var genderWidget = ValueListenableBuilder(
        valueListenable: _gender,
        builder: (context, gender, _) {
          return Container(
              margin: EdgeInsets.only(left: 15),
              child: DropdownButton<int>(
                elevation: 10,
                underline: SizedBox(),
                value: gender,
                onChanged: (int value) {
                  _gender.value = value;
                },
                items: _genderDatas,
              ));
        });

    var educationWidget = ValueListenableBuilder(
        valueListenable: _education,
        builder: (context, education, _) {
          return Container(
              margin: EdgeInsets.only(left: 15),
              child: DropdownButton<int>(
                elevation: 10,
                underline: SizedBox(),
                value: education,
                onChanged: (int value) {
                  _education.value = value;
                },
                items: _educationDatas,
              ));
        });

    var postWidget = ValueListenableBuilder<Post>(
        valueListenable: _post,
        builder: (context, post, _) {
          return TextField(
              enableInteractiveSelection: false,
              controller: TextEditingController(
                  text: post == null
                      ? ''
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
                    _post.value = post;
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
                    _dept.value = dept;
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
        builder: (context, emp, _) {
          return TextField(
              enableInteractiveSelection: false,
              controller: TextEditingController(
                  text: emp == null
                      ? ''
                      : ('#' + emp.eid.toString() + ' ' + emp.name)),
              onTap: () {
                Navigator.push<Employee>(
                  context,
                  MaterialPageRoute<Employee>(
                      builder: (context) => EmployeePage(isSelect: true)),
                ).then((Employee emp) {
                  if (emp == null) {
                    showSnackBar(Strings.msg_select_empty);
                  } else {
                    _employee.value = emp;
                  }
                });
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              decoration: InputDecoration(
                labelStyle: style,
                labelText: emp == null
                    ? Strings.employee_info_leader_hint
                    : Strings.employee_info_leader,
              ));
        });

    var gap = SizedBox(height: 10);

    return ListView(
      padding: EdgeInsets.all(15.0),
      children: <Widget>[
        nameWidget,
        gap,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(Strings.employee_info_birthday + ':  ', style: style),
            yearWidget,
            Text(' 一 ', style: style),
            monthWidget,
            Text(' 一 ', style: style),
            dayWidget,
          ],
        ),
        gap,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(Strings.employee_info_gender + ':  ', style: style),
            genderWidget,
          ],
        ),
        gap,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(Strings.employee_info_education + ':  ', style: style),
            educationWidget,
          ],
        ),
        gap,
        phoneWidget,
        gap,
        schoolWidget,
        gap,
        hometownWidget,
        gap,
        descriptionWidget,
        gap,
        salaryWidget,
        gap,
        postWidget,
        gap,
        deptWidget,
        gap,
        employeeWidget,
      ],
    );
  }

  @override
  void success<E extends IModel>(String id, E t) {
    if (Ids.ID_ADD_EMPLOYEE + hashCode.toString() == id && t is IModel) {
      if (Constants.STATUS_SUCCESS == t.status) {
        Navigator.pop<String>(context, Strings.employee_add_success);
      }
    }
  }
}
