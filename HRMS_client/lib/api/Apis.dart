import 'dart:async';

import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/events/Event.dart';
import 'package:flutter_hrms/models/AttendanceBean.dart';
import 'package:flutter_hrms/models/AttendanceEmployeeBean.dart';
import 'package:flutter_hrms/models/AttendanceStatistic.dart';
import 'package:flutter_hrms/models/BaseModel.dart';
import 'package:flutter_hrms/models/DepartmentBean.dart';
import 'package:flutter_hrms/models/EmployeeBean.dart';
import 'package:flutter_hrms/models/IBean.dart';
import 'package:flutter_hrms/models/IModel.dart';
import 'package:flutter_hrms/models/Message.dart';
import 'package:flutter_hrms/models/PostBean.dart';
import 'package:flutter_hrms/models/PostLevelBean.dart';
import 'package:flutter_hrms/models/SalaryBean.dart';
import 'package:flutter_hrms/models/SalaryEmployeeBean.dart';

import 'Network.dart';
import 'dart:convert';

// 抽出post的通用方法
void _post<T extends IBean>(String id, String url, {T t, Map<String, String> map}) {
  var _delay = 300;
  void funE() {
    Constants.eventBus.fire(FEvent(id, Strings.msg_not_connection));
  }

  void funC() {
    Future.delayed(Duration(milliseconds: _delay), () {}).then((_) {
      Constants.eventBus.fire(CEvent(id));
    });
  }

  Constants.eventBus.fire(SEvent(id));
  Future.delayed(Duration(milliseconds: _delay), () {}).then((_) {
    NetWork.isConnected().then((isConnected) {
      if (isConnected) {
        if (t == null) {
          NetWork.post(url, params: map).catchError((error) {
            print(error);
            funE();
          }).then((data) {
            if (data != null) {
              Map<String, dynamic> map = json.decode(data);
              Constants.eventBus.fire(BeanEvent<IModel>(id, IModel.fromJson(map)));
            }
          }).whenComplete(() {
            funC();
          });
        } else {
          NetWork.post(url, params: map).catchError((error) {
            funE();
          }).then((data) {
            if (data != null) {
              Map<String, dynamic> map = json.decode(data);
              Constants.eventBus.fire(
                  BeanEvent<BaseModel<T>>(id, BaseModel<T>.fromJson(map, t)));
            }
          }).whenComplete(() {
            funC();
          });
        }
      } else
        funE();
    });
  });
}

// 员工相关api
class API$Employee {
  final String _employee_uri = NetWork.host + '/employee/';

  // 获取首页公告
  getStatistic(String id) {
    String url = _employee_uri + 'banner';
    _post(id, url, t: Message());
  }

  // 管理员登陆
  login(String id, String username, String password) {
    String url = _employee_uri + 'login';
    var datas = {'username': username, 'password': password};
    _post(id, url, map: datas);
  }

  // 获取单个员工
  getEmployee(String id, int eid) {
    String url = _employee_uri + 'get';
    var datas = {'eid': eid.toString()};
    _post(id, url, map: datas, t: EmployeeBean());
  }

  // 获取所有员工
  getAllEmployee(String id) {
    String url = _employee_uri + 'get_all';
    _post(id, url, t: EmployeeBean());
  }

  // 获取所有离职员工
  getAllQuitEmployee(String id) {
    String url = _employee_uri + 'get_all_quit';
    _post(id, url, t: EmployeeBean());
  }

  // 添加员工
  addEmployee(
      String id,
      String name,
      int gender,
      String birthday_year,
      String birthday_month,
      String birthday_day,
      String hometown,
      String phone,
      String school,
      int education,
      String salary,
      String description,
      int pid,
      int did,
      int peid) {
    String url = _employee_uri + 'add';
    var datas = {
      'name': name,
      'gender': gender.toString(),
      'year': birthday_year,
      'month': birthday_month,
      'day': birthday_day,
      'hometown': hometown,
      'phone': phone,
      'school': school,
      'education': education.toString(),
      'salary': salary,
      'description': description,
      'pid': pid.toString(),
      'did': did.toString(),
      'peid': peid.toString(),
    };

    _post(id, url, map: datas);
  }

  // 员工离职
  quitEmployee(String id, int eid) {
    String url = _employee_uri + 'quit';
    var datas = {'eid': eid.toString()};
    _post(id, url, map: datas);
  }

  // 员工复职
  recoveryEmployee(String id, int eid) {
    String url = _employee_uri + 'recovery';
    var datas = {'eid': eid.toString()};
    _post(id, url, map: datas);
  }

  // 员工异动
  changeEmployee(
      String id, int eid, String salary, int pid, int did, int peid) {
    String url = _employee_uri + 'change';
    var datas = {
      'eid': eid.toString(),
      'salary': salary,
      'pid': pid.toString(),
      'did': did.toString(),
      'peid': peid.toString(),
    };
    _post(id, url, map: datas);
  }
}

// 部门相关api
class API$Department {
  final String _department_uri = NetWork.host + '/department/';

  // 添加部门
  addDepartment(String id, String name, int pdid, String description) {
    String url = _department_uri + 'add';
    var datas = {
      'name': name,
      'pdid': pdid.toString(),
      'description': description
    };
    _post(id, url, map: datas);
  }

  // 弃用部门
  quitDepartment(String id, int did) {
    String url = _department_uri + 'quit';
    var datas = {'did': did.toString()};
    _post(id, url, map: datas);
  }

  // 启用部门
  recoveryDepartment(String id, int did) {
    String url = _department_uri + 'recovery';
    var datas = {'did': did.toString()};
    _post(id, url, map: datas);
  }

  // 部门异动
  changeEmployee(
      String id, int did, String name, int pdid, String description) {
    String url = _department_uri + 'change';
    var datas = {
      'did': did.toString(),
      'name': name,
      'pdid': pdid.toString(),
      'description': description,
    };
    _post(id, url, map: datas);
  }

  // 获取单个部门
  getDepartment(String id, int did) {
    String url = _department_uri + 'get';
    var datas = {'did': did.toString()};
    _post(id, url, map: datas, t: DepartmentBean());
  }

  // 获取所有部门
  getAllDepartment(String id) {
    String url = _department_uri + 'get_all';
    _post(id, url, t: DepartmentBean());
  }

  // 获取所有部门
  getAllQuitDepartment(String id) {
    String url = _department_uri + 'get_all_quit';
    _post(id, url, t: DepartmentBean());
  }
}

// 职位相关api
class API$Post {
  final String _post_uri = NetWork.host + '/post/';

  // 获取职位
  getPost(String id, int pid) {
    String url = _post_uri + 'get';
    var datas = {'pid': pid.toString()};
    _post(id, url, map: datas, t: PostBean());
  }

  // 增加职位
  addPost(String id, String name, String lid, String description) {
    String url = _post_uri + 'add';
    var datas = {'name': name, 'lid': lid, 'description': description};
    _post(id, url, map: datas);
  }

  // 弃用职位
  quitPost(String id, int pid) {
    String url = _post_uri + 'quit';
    var datas = {'pid': pid.toString()};
    _post(id, url, map: datas);
  }

  // 启用职位
  recoveryPost(String id, int pid) {
    String url = _post_uri + 'recovery';
    var datas = {'pid': pid.toString()};
    _post(id, url, map: datas);
  }

  // 获取职位
  getPostByLevel(String id, String lid) {
    String url = _post_uri + 'post_level/get';
    var datas = {'lid': lid};
    _post(id, url, map: datas, t: PostLevelBean());
  }

  // 获取所有职位
  getAllPostByLevel(String id) {
    String url = _post_uri + 'post_level/get_all';
    _post(id, url, t: PostLevelBean());
  }

  // 获取所有职位
  getAllQuitPostByLevel(String id) {
    String url = _post_uri + 'post_level/get_all_quit';
    _post(id, url, t: PostLevelBean());
  }

  // 获取所有职位 (新增/修改员工使用)
  getAllSelectPostByLevel(String id) {
    String url = _post_uri + 'post_level/get_all_select';
    _post(id, url, t: PostLevelBean());
  }
}

// 考勤相关
class API$Attendance {
  final String _attendance_uri = NetWork.host + '/attendance/';

  // 获取考勤列表详细
  getAttendance(String id, int eid, String date) {
    String url = _attendance_uri + 'get';
    var datas = {'eid': eid.toString(), 'date': date};
    _post(id, url, map: datas, t: AttendanceBean());
  }

  // 获取考勤列表
  getAllAttendance(String id, int eid) {
    String url = _attendance_uri + 'get_all';
    var datas = {'eid': eid.toString()};
    _post(id, url, map: datas, t: AttendanceStatistic());
  }

  // 获取所有考勤人员
  getAllAttendanceEmployee(String id) {
    String url = _attendance_uri + 'get_all_emp';
    _post(id, url, t: AttendanceEmployeeBean());
  }
}

// 工资相关api
class API$Salary {
  final String _salary_uri = NetWork.host + '/salary/';

  // 获取工资详细列表
  getAllSalary(String id, int eid, String lid) {
    String url = _salary_uri + 'get_all';
    var datas = {'eid': eid.toString(), 'lid': lid};
    _post(id, url, map: datas, t: SalaryBean());
  }

  // 获取所有工资人员
  getAllSalaryEmployee(String id) {
    String url = _salary_uri + 'get_all_emp';
    _post(id, url, t: SalaryEmployeeBean());
  }
}
