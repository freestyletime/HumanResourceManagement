import 'package:flutter/material.dart';
import 'package:flutter_hrms/models/AttendanceEmployeeBean.dart';
import 'package:flutter_hrms/models/AttendanceStatistic.dart';
import 'package:flutter_hrms/models/DepartmentBean.dart';
import 'package:flutter_hrms/models/EmployeeBean.dart';
import 'package:flutter_hrms/models/IBean.dart';
import 'package:flutter_hrms/models/PostBean.dart';
import 'package:flutter_hrms/models/SalaryEmployeeBean.dart';
import 'package:flutter_hrms/pages/AttendanceDetailListPage.dart';
import 'package:flutter_hrms/pages/DepartmentDetailPage.dart';
import 'package:flutter_hrms/pages/EmployeeDetailPage.dart';
import 'package:flutter_hrms/pages/PostDetailPage.dart';
import 'package:flutter_hrms/pages/SalaryDetailPage.dart';

import '../AttendanceDetailPage.dart';

// 列表条目回调时的统一封装类 
// Union itemclick callback encapsulation
class CallbackController {
  final BuildContext context;
  final Function result;
  final bool isSelect;

  CallbackController(this.context, {this.result, this.isSelect = false});

  void itemClick(IBean bean) {
    if (bean == null) Navigator.pop(context, null);

    if (isSelect) {
      if (bean is EmployeeBean) {
        Navigator.pop(context, bean.employee);
      } else if (bean is DepartmentBean) {
        Navigator.pop(context, bean.dept);
      } else if (bean is PostBean) {
        Navigator.pop(context, bean.post);
      }
    } else {
      if (bean is EmployeeBean) {
        Navigator.push<String>(
          context,
          MaterialPageRoute(builder: (context) => EmployeeDetailPage(bean)),
        ).then((val) {
          if (result != null) result(val);
        });
      } else if (bean is DepartmentBean) {
        Navigator.push<String>(
          context,
          MaterialPageRoute(builder: (context) => DepartmentDetailPage(bean)),
        ).then((val) {
          if (result != null) result(val);
        });
      } else if (bean is PostBean) {
        Navigator.push<String>(
          context,
          MaterialPageRoute(builder: (context) => PostDetailPage(bean)),
        ).then((val) {
          if (result != null) result(val);
        });
      } else if (bean is SalaryEmployeeBean) {
        Navigator.push<String>(
          context,
          MaterialPageRoute(builder: (context) => SalaryDetailPage(bean)),
        ).then((val) {
          if (result != null) result(val);
        });
      } else if (bean is AttendanceEmployeeBean) {
        Navigator.push<String>(
          context,
          MaterialPageRoute(builder: (context) => AttendanceDetailPage(bean)),
        ).then((val) {
          if (result != null) result(val);
        });
      } else if(bean is AttendanceStatistic) {
         Navigator.push<String>(
          context,
          MaterialPageRoute(builder: (context) => AttendanceDetailListPage(bean.eid, bean.date.substring(0, 7))),
        ).then((val) {
          if (result != null) result(val);
        });
      }
    }
  }
}
