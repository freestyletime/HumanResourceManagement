import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/events/BeanEvent.dart';
import 'package:flutter_hrms/models/IModel.dart';

import 'Network.dart';
import 'dart:convert';

// 员工相关api
class API$Employee {
  login(String id, String username, String password) {
    String url = NetWork.HOST + '/employee/login';
    var datas = {'username': username, 'password': password};
    NetWork.post(url, params: datas).then((data) {
      if (data != null) {
        Map<String, dynamic> map = json.decode(data);
        Constants.eventBus.fire(BeanEvent<IModel>(id, new IModel.fromJson(map)));
      }
    });
  }
}
