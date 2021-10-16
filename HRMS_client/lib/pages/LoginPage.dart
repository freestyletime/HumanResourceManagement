import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/IModel.dart';
import 'package:flutter_hrms/pages/HomePage.dart';
import 'package:flutter_hrms/widgets/GradientText.dart';
import 'package:flutter_hrms/widgets/SigninButton.dart';

import 'BasePage.dart';

class LoginPage extends StatefulWidget {
  static final String tag = 'login-page';

  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends BasePageState<LoginPage> {
  // 用户名
  String _userName;
  // 密码
  String _password;
  // 输入框控制
  TextEditingController _userNameCtl;
  TextEditingController _passwordNameCtl;

  @override
  void initState() {
    _userName = '';
    _password = '';
    _userNameCtl = TextEditingController();
    _passwordNameCtl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 调用登陆接口
  void _login() {
    if (_userName.isEmpty || _password.isEmpty) {
      showSnackBar(Strings.msg_key_empty);
    } else {
      service
          .getEmployeeAPI()
          .login(Ids.ID_LOGIN + hashCode.toString(), _userName, _password);
      FocusScope.of(scaffoldkey.currentContext).requestFocus(FocusNode());
    }
  }

  @override
  void success<E extends IModel>(String id, E t) {
    if (Ids.ID_LOGIN + hashCode.toString() == id && t is IModel) {
      if (Constants.STATUS_SUCCESS == t.status) {
        // 用户验证成功 进入首页
        Future.delayed(Duration(milliseconds: 100), () {
          Navigator.of(context).pushNamedAndRemoveUntil(
              HomePage.tag, (router) => router == null);
        });
      } else {
        if (Codes.CODE_USER_NOT_EXIST == t.code) {
          _userNameCtl.clear();
          _userName = '';
        } else if (Codes.CODE_PWD_WRONG == t.code) {
          _passwordNameCtl.clear();
          _password = '';
        }
      }
    }
  }

  @override
  AppBar getAppBar() {
    return null;
  }

  @override
  Widget getBody() {
    final loginTitleWidget = GradientText(Strings.appTitle,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        gradient: LinearGradient(colors: [Colors.pink, Colors.orangeAccent]));

    final loginObjectsWidgets = Container(
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
                    controller: _userNameCtl,
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
                    controller: _passwordNameCtl,
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

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          loginTitleWidget,
          loginObjectsWidgets,
        ],
      ),
    );
  }
}
