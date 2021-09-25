import 'package:event_bus/event_bus.dart';

// 全局的变量及常量标志
class Constants {
  //全局的event_bus
  static final EventBus eventBus = EventBus();
  // 后台返回状态 成功
  static final int STATUS_SUCCESS = 0;
  // 后台返回状态 失败
  static final int STATUS_FAILURE = 1;
  // ______________________________________________
  //当前的主题模式
  static int currentTheme = dayTheme;
  //日间模式
  static final int dayTheme = 1;
  //夜间模式
  static final int nightTheme = 2;
  // ______________________________________________
}

// 全局的字符串常量
class Strings {
  static final String appTitle = '人事信息管理系统';
  static final String msg_key_empty = '关键信息不能为空';


  static final String userName = '用户名';
  static final String hint_userName = '请输入用户名';
  static final String password = '密码';
  static final String hint_password = '请输入密码';
  static final String login = '登陆';
}

//所有的请求id
class Ids {
 static final String ID_LOGIN = 'id_login';
}

// 所有的Code
class Codes {
  static final String CODE_SUCCESS = "CE00000";
  
}