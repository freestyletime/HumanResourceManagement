import 'package:flutter_hrms/api/Apis.dart';
import 'package:url_launcher/url_launcher.dart';

class Service {
  // 打电话服务
  void call(String number) => launch("tel:$number");
  // 发短信服务
  void sendSms(String number) => launch("sms:$number");
  // 发邮件服务
  void sendEmail(String email) => launch("mailto:$email");
  // 员工api
  API$Employee getEmployeeAPI() => API$Employee();
  // 职位api
  API$Post getPostAPI() => API$Post();
  // 部门api
  API$Department getDepartmentAPI() => API$Department();
  // 考勤api
  API$Attendance getAttendanceAPI() => API$Attendance();
  // 工资api
  API$Salary getSalaryAPI() => API$Salary();
}