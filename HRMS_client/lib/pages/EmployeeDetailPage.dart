import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/BaseModel.dart';
import 'package:flutter_hrms/models/EmployeeBean.dart';
import 'package:flutter_hrms/models/IModel.dart';
import 'package:flutter_hrms/pages/BasePage.dart';
import 'package:flutter_hrms/pages/EmployeeChangePage.dart';
import 'package:flutter_hrms/widgets/DetailHeaderView.dart';
import 'package:flutter_hrms/widgets/Dialog.dart';

// 员工详情页
class EmployeeDetailPage extends StatefulWidget {
  final EmployeeBean bean;

  EmployeeDetailPage(this.bean);

  @override
  _EmployeeDetailPageState createState() => _EmployeeDetailPageState();
}

class _EmployeeDetailPageState extends BasePageState<EmployeeDetailPage> {
  static const String MENU_CALL = 'A';
  static const String MENU_MSG = 'B';
  static const String MENU_EMAIL = 'C';
  static const String MENU_CHANGE = 'D';
  static const String MENU_QUIT = 'E';
  static const String MENU_RECOVERY = 'F';

  // 统一的回调控制器
  var _controller;
  // 员工数据
  var _data = ValueNotifier<EmployeeBean>(null);

  void _getData() {
    service.getEmployeeAPI().getEmployee(
        Ids.ID_GET_EMPLOYEE + hashCode.toString(), widget.bean.employee.eid);
  }

  void _quit() {
    service.getEmployeeAPI().quitEmployee(
        Ids.ID_QUIT_EMPLOYEE + hashCode.toString(), widget.bean.employee.eid);
  }

  void _recovery() {
    service.getEmployeeAPI().recoveryEmployee(
        Ids.ID_RECOVERY_EMPLOYEE + hashCode.toString(),
        widget.bean.employee.eid);
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
    _data.value = widget.bean;
    super.initState();
  }

  @override
  AppBar getAppBar() {
    var pops = List<PopupMenuItem<String>>();
    pops.add(_getPopup(Icons.call, Strings.employee_call, MENU_CALL));
    pops.add(_getPopup(Icons.message, Strings.employee_msg, MENU_MSG));
    pops.add(_getPopup(Icons.email, Strings.employee_email, MENU_EMAIL));

    if (!(widget.bean.leader == null && widget.bean.pdept == null)) {
      if (Constants.WORK_WORK == widget.bean.employee.status) {
        pops.add(_getPopup(
            Icons.track_changes, Strings.employee_change, MENU_CHANGE));
        pops.add(
            _getPopup(Icons.exit_to_app, Strings.employee_quit, MENU_QUIT));
      } else {
        pops.add(_getPopup(
            Icons.exit_to_app, Strings.employee_recovery, MENU_RECOVERY));
      }
    }

    return AppBar(
        centerTitle: true,
        title: Text(Strings.employee_detail),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: (() {
                if (!isLoading.value) _getData();
              })),
          PopupMenuButton<String>(
            icon: Icon(Icons.menu),
            itemBuilder: (BuildContext context) => pops,
            onSelected: (String action) {
              switch (action) {
                case MENU_CALL:
                  service.call(_data.value.employee.phone);
                  break;
                case MENU_MSG:
                  service.sendSms(_data.value.employee.phone);
                  break;
                case MENU_EMAIL:
                  service.sendEmail(_data.value.employee.email);
                  break;
                case MENU_CHANGE:
                  Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EmployeeChangePage(widget.bean)),
                  ).then(_result);
                  break;
                case MENU_RECOVERY:
                  DialogUtils.alert(context,
                      text: Strings.employee_recovery_hint,
                      yesCallBack: _recovery);
                  break;
                case MENU_QUIT:
                  if (widget.bean.leader == null && widget.bean.pdept == null) {
                    showSnackBar(Strings.employee_quit_perimission_deny);
                    return;
                  }

                  DialogUtils.alert(context,
                      text: Strings.employee_quit_hint, yesCallBack: _quit);
                  break;
              }
            },
          )
        ]);
  }

  @override
  Widget getBody() {
    Widget _getDetailElement(EmployeeBean bean) {
      var style = TextStyle(fontSize: 20);
      String gender = Strings.employee_male;
      String education = Strings.employee_bachelor;
      String status = Strings.employee_stay_work;

      if (Constants.GENDER_FEMALE == bean.employee.gender)
        gender = Strings.employee_female;
      if (Constants.EDUCATION_OTHER == bean.employee.education)
        education = Strings.employee_education_other;
      else if (Constants.EDUCATION_COLLEGE == bean.employee.education)
        education = Strings.employee_college;
      else if (Constants.EDUCATION_BACHELOR == bean.employee.education)
        education = Strings.employee_bachelor;
      else if (Constants.EDUCATION_MASTER == bean.employee.education)
        education = Strings.employee_master;
      else if (Constants.EDUCATION_PHD == bean.employee.education)
        education = Strings.employee_phd;

      if (Constants.WORK_LEAVE == bean.employee.status)
        status = Strings.employee_leave_work;

      return ListView(children: <Widget>[
        DetailHeaderView(
            id: bean.employee.eid.toString(),
            name: bean.employee.name,
            other: bean.employee.description),

        Container(
          margin: EdgeInsets.only(top: 35, bottom: 35, right: 15, left: 15),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              //阴影效果
              BoxShadow(
                offset: Offset(5, 5), //阴影在X轴和Y轴上的偏移
                color: Color.fromRGBO(16, 20, 188, 10), //阴影颜色
                blurRadius: 15.0, //阴影程度
                spreadRadius: -5.0, //阴影扩散的程度 取值可以正数,也可以是负数
              ),
            ],
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.black,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                Strings.employee_info_gender + ': ' + gender,
                style: style,
              ),
              Divider(),
              Text(
                Strings.employee_info_postName + ': ' + bean.post.postName,
                style: style,
              ),
              Divider(),
              Text(
                Strings.employee_info_lid +
                    ': ' +
                    bean.postLevel.lid +
                    ' (' +
                    bean.postLevel.description +
                    ')',
                style: style,
              ),
              Divider(),
              Text(
                Strings.employee_info_dept +
                    ': ' +
                    '#' +
                    bean.dept.did.toString() +
                    ' ' +
                    bean.dept.departmentName,
                style: style,
              ),
              Divider(),
              Text(
                Strings.employee_info_salary +
                    ': ' +
                    bean.employee.salary.toString(),
                style: style,
              ),
              Divider(),
              Text(
                Strings.employee_info_phone + ': ' + bean.employee.phone,
                style: style,
              ),
              Divider(),
              Text(
                Strings.employee_info_email + ': ' + bean.employee.email,
                style: style,
              ),
              Divider(),
              Text(
                Strings.employee_info_hometown + ': ' + bean.employee.hometown,
                style: style,
              ),
              Divider(),
              Text(
                Strings.employee_info_birthday + ': ' + bean.employee.birthday,
                style: style,
              ),
              Divider(),
              Text(
                Strings.employee_info_education + ': ' + education,
                style: style,
              ),
              Divider(),
              Text(
                Strings.employee_info_school + ': ' + bean.employee.school,
                style: style,
              ),
              Divider(),
              Text(
                Strings.employee_info_leader +
                    ': ' +
                    (bean.leader == null
                        ? ' '
                        : '#' +
                            bean.leader.eid.toString() +
                            ' ' +
                            bean.leader.name),
                style: style,
              ),
              Divider(),
              Text(
                Strings.employee_info_pdept +
                    ': ' +
                    (bean.pdept == null
                        ? ' '
                        : '#' +
                            bean.pdept.did.toString() +
                            ' ' +
                            bean.pdept.departmentName),
                style: style,
              ),
              Divider(),
              Text(
                Strings.employee_info_entryTime +
                    ': ' +
                    bean.employee.entryTime,
                style: style,
              ),
              Divider(),
              Text(
                Strings.employee_info_status + ': ' + status,
                style: style,
              ),
            ],
          ),
        ),

        // //功能按钮
        // FunctionButton(Icons.call, Strings.employee_call,
        //     start: Colors.redAccent,
        //     end: Colors.white,
        //     style: style,
        //     fun: () {}),
        // FunctionButton(Icons.email, Strings.employee_email,
        //     start: Colors.pink, end: Colors.white, style: style, fun: () {}),
        // FunctionButton(Icons.track_changes, Strings.employee_change,
        //     start: Colors.green, end: Colors.white, style: style, fun: () {}),
        // FunctionButton(Icons.exit_to_app, Strings.employee_quit,
        //     start: Colors.yellow[700],
        //     end: Colors.white,
        //     style: style,
        //     fun: () {}),
      ]);
    }

    return ValueListenableBuilder<EmployeeBean>(
        valueListenable: _data,
        builder: (context, data, _) {
          return _getDetailElement(data);
        });
  }

  @override
  void success<E extends IModel>(String id, E t) {
    if (Ids.ID_GET_EMPLOYEE + hashCode.toString() == id &&
        t is BaseModel<EmployeeBean>) {
      if (Constants.STATUS_SUCCESS == t.status) {
        if (t.data != null && t.data.length != 0) {
          _data.value = t.data[0];
        }
      }
    } else if (Ids.ID_QUIT_EMPLOYEE + hashCode.toString() == id &&
        t is IModel) {
      if (Constants.STATUS_SUCCESS == t.status) {
        Navigator.pop<String>(context, Strings.employee_quit_success);
      }
    } else if (Ids.ID_RECOVERY_EMPLOYEE + hashCode.toString() == id &&
        t is IModel) {
      if (Constants.STATUS_SUCCESS == t.status) {
        Navigator.pop<String>(context, Strings.employee_recovery_success);
      }
    }
  }
}
