import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/api/Apis.dart';
import 'package:flutter_hrms/events/BeanEvent.dart';
import 'package:flutter_hrms/models/IModel.dart';
import 'package:flutter_hrms/widgets/SigninButton.dart';

class LoginPage extends StatefulWidget {
  static final String tag = 'login-page';
  LoginPage({Key key, this.title}) : super(key: key);
  
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 为了获取全局上下文
  var _scaffoldkey = new GlobalKey<ScaffoldState>();
  // 请求接口
  API$Employee _api;
  // 用户名
  String _userName;
  // 密码
  String _password;
  // 订阅者
  StreamSubscription subscription;

  @override
  void initState() {
    _userName = '';
    _password = '';
    _api = API$Employee();

    subscription = Constants.eventBus.on<BeanEvent<IModel>>().listen((event) {
      if (Ids.ID_LOGIN == event.id) {
        var model = event.data;
        var snackBar = SnackBar(
            content: new Text(model.msg), duration: Duration(seconds: 1));
        _scaffoldkey.currentState.showSnackBar(snackBar);
        if (Constants.STATUS_SUCCESS == model.status) {
          // 请求成功 进入首页
        } else {}
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  // 调用登陆接口
  void _login() {
    if (_userName.isEmpty || _password.isEmpty) {
      var snackBar = SnackBar(
          content: new Text(Strings.msg_key_empty),
          duration: Duration(seconds: 1));
      _scaffoldkey.currentState.showSnackBar(snackBar);
    } else
      _api.login(Ids.ID_LOGIN, _userName, _password);
  }

  @override
  Widget build(BuildContext context) {
    final pageObjectsWidgets = Container(
      margin: EdgeInsets.all(10.0),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25.0))),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              // 登陆框
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      hintText: Strings.hint_userName,
                      labelText: Strings.userName,
                    ),
                    onChanged: (String value) {
                      _userName = value;
                    }),
              ),
              // 密码框
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      hintText: Strings.hint_password,
                      labelText: Strings.password,
                    ),
                    onChanged: (String value) {
                      _password = value;
                    }),
              ),
              // 登陆按钮
              SigninButton(
                  child: Text(Strings.login,
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                  onPressed: _login)
            ])),
      ),
    );

    return Scaffold(
      key: _scaffoldkey,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.blue,
              Colors.lightBlueAccent,
            ]),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                Strings.appTitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              pageObjectsWidgets,
            ],
          ),
        ),
      ),
    );
  }
}
