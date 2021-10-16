import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hrms/ServiceLocator.dart';
import 'package:flutter_hrms/pages/AttendancePage.dart';
import 'package:flutter_hrms/pages/DepartmentPage.dart';
import 'package:flutter_hrms/pages/DepartmentQuitPage.dart';
import 'package:flutter_hrms/pages/EmployeePage.dart';
import 'package:flutter_hrms/pages/EmployeeQuitPage.dart';
import 'package:flutter_hrms/pages/HomePage.dart';
import 'package:flutter_hrms/pages/LoginPage.dart';
import 'package:flutter_hrms/pages/PostPage.dart';
import 'package:flutter_hrms/pages/PostQuitPage.dart';
import 'package:flutter_hrms/pages/SalaryPage.dart';


void main() {
  //初始化依赖注入容器
  initLocator();
  //初始化app
  runApp(FlutterHRMS());
}

class FlutterHRMS extends StatefulWidget {
  @override
  _FlutterHRMSState createState() => _FlutterHRMSState();
}

class _FlutterHRMSState extends State<FlutterHRMS> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.blueGrey,
          accentColor: Colors.orangeAccent),
      // 公共跳转路由
      routes: <String, WidgetBuilder>{
        HomePage.tag: (_) => HomePage(),
        PostPage.tag: (_) => PostPage(),
        LoginPage.tag: (_) => LoginPage(),
        SalaryPage.tag: (_) => SalaryPage(),
        EmployeePage.tag: (_) => EmployeePage(),
        PostQuitPage.tag: (_) => PostQuitPage(),
        AttendancePage.tag: (_) => AttendancePage(),
        DepartmentPage.tag: (_) => DepartmentPage(),
        EmployeeQuitPage.tag: (_) => EmployeeQuitPage(),
        DepartmentQuitPage.tag: (_) => DepartmentQuitPage(),
      },
      home: LoginPage(),
    );
  }
}
