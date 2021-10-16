import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/BaseModel.dart';
import 'package:flutter_hrms/models/IModel.dart';
import 'package:flutter_hrms/models/Message.dart';
import 'package:flutter_hrms/pages/AttendancePage.dart';
import 'package:flutter_hrms/pages/BasePage.dart';
import 'package:flutter_hrms/pages/DepartmentPage.dart';
import 'package:flutter_hrms/pages/EmployeePage.dart';
import 'package:flutter_hrms/pages/PostPage.dart';
import 'package:flutter_hrms/pages/SalaryPage.dart';
import 'package:flutter_hrms/widgets/FunctionButton.dart';
import 'package:marquee/marquee.dart';


class HomePage extends StatefulWidget {
  static final String tag = 'home-page';

  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BasePageState<HomePage> {
  //公告数据
  var _data = ValueNotifier<String>(Strings.msg_data_empty);

  void _getData() {
    service
        .getEmployeeAPI()
        .getStatistic(Ids.ID_GET_STATISTIC + hashCode.toString());
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void success<E extends IModel>(String id, E t) {
    if (Ids.ID_GET_STATISTIC + hashCode.toString() == id &&
        t is BaseModel<Message>) {
      if (Constants.STATUS_SUCCESS == t.status) {
        if (t.data != null && t.data.length != 0) {
          _data.value = t.data[0].msg;
        }
      } else {
        _data.value = Strings.msg_data_empty;
      }
    }
  }

  @override
  AppBar getAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(Strings.appTitle),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.autorenew),
            onPressed: (() {
              if (!isLoading.value) _getData();
            }))
      ],
    );
  }

  @override
  Widget getBody() {
    var _style = TextStyle(
        color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold);
    var _border = Divider(height: .0, color: Colors.black);
    var _header = Image.asset('assets/images/header.jpg', fit: BoxFit.contain);
    var _banner = Semantics(
      readOnly: true,
      child: Container(
        height: 40,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.black,
            Colors.grey,
          ]),
        ),
        child: ValueListenableBuilder<String>(
          valueListenable: _data,
          builder: (context, _data, _) => Marquee(
            text: _data,
            scrollAxis: Axis.horizontal,
            blankSpace: 200.0,
            style: _style,
          ),
        ),
      ),
    );

    Widget _getModel(Color start, Color end, IconData icon, String model, {Function fun}) {
      return FunctionButton(icon, model, start: start, end: end, style: _style, fun: fun);
    }

    // 页面跳转
    Function toModel(String model) {
      return () {
        Navigator.of(context).pushNamed(model);
      };
    }

    return ListView(padding: EdgeInsets.all(0), children: <Widget>[
      // 图片
      _header,
      _border,
      // 公告
      _banner,
      _border,
      // 员工管理入口
      _getModel(Colors.redAccent, Colors.white, Icons.people, Strings.employee,
          fun: toModel(EmployeePage.tag)),
      _border,
      // 部门管理入口
      _getModel(Colors.purple, Colors.white, Icons.device_hub, Strings.department,
          fun: toModel(DepartmentPage.tag)),
      _border,
      // 职位管理入口
      _getModel(Colors.pink, Colors.white, Icons.format_paint, Strings.post,
          fun: toModel(PostPage.tag)),
      _border,
      // 考勤管理入口
      _getModel(Colors.orange, Colors.white, Icons.playlist_add_check,
          Strings.attendance,
          fun: toModel(AttendancePage.tag)),
      _border,
      // 工资管理入口
      _getModel(Colors.blueAccent, Colors.white, Icons.monetization_on,
          Strings.salary,
          fun: toModel(SalaryPage.tag)),
      _border
    ]);
  }
}
