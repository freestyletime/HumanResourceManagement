import 'package:flutter_hrms/models/IModel.dart';

import 'IEvent.dart';

// 请求开始时返回的事件
class SEvent extends IEvent {
  SEvent(String id):super(id);
}

// 请求成功时返回的携带对象的事件
class BeanEvent<T extends IModel> extends IEvent {
  T data;
  BeanEvent(String id, T data) : this.data = data, super(id);
}

// 请求失败时返回的事件
class FEvent extends IEvent {
  String msg;
  FEvent(String id, String msg)
      : this.msg = msg,
        super(id);
}

// 请求完成时返回的事件
class CEvent extends IEvent {
  CEvent(String id):super(id);
}