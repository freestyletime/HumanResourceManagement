import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/Service.dart';
import 'package:flutter_hrms/ServiceLocator.dart';
import 'package:flutter_hrms/events/Event.dart';
import 'package:flutter_hrms/models/IModel.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// 基础UI模版类
abstract class BasePageState<T extends StatefulWidget> extends State<T> {
  // 全局上下文
  var scaffoldkey = GlobalKey<ScaffoldState>();
  // 网络请求成功时返回的数据
  void success<E extends IModel>(String id, E t);
  // 页面获取标题
  AppBar getAppBar();
  // 页面内容
  Widget getBody();
  // 网络请求开始的订阅者
  StreamSubscription s_subscription;
  // 网络请求成功的订阅者
  StreamSubscription d_subscription;
  // 网络请求完成的订阅者
  StreamSubscription c_subscription;
  // 网络请求失败的订阅者
  StreamSubscription f_subscription;
  // 是否正在显示加载框 0-未显示
  int _isLoading = 0;
  // loading框相关状态参数
  var isLoading = ValueNotifier<bool>(false);
  // 各种可能用到的服务
  final Service service = locator<Service>();

  void showSnackBar(String msg) {
    var snackBar =
        SnackBar(content: new Text(msg), duration: Duration(seconds: 1));
    scaffoldkey.currentState.showSnackBar(snackBar);
  }

  @override
  void initState() {
    s_subscription = Constants.eventBus.on<SEvent>().listen((event) {
      if (event.id.endsWith(hashCode.toString())) {
        if (_isLoading == 0) {
          isLoading.value = true;
        }
        _isLoading += 1;
      }
    });

    d_subscription = Constants.eventBus.on<BeanEvent>().listen((event) {
      if (event.id.endsWith(hashCode.toString())) {
        success(event.id, event.data);
        if (Constants.STATUS_FAILURE == event.data.status) {
          showSnackBar(event.data.msg);
        }
      }
    });

    c_subscription = Constants.eventBus.on<CEvent>().listen((event) {
      if (event.id.endsWith(hashCode.toString())) {
        _isLoading -= 1;
        if (_isLoading <= 0) {
          _isLoading = 0;
          isLoading.value = false;
        }
      }
    });

    f_subscription = Constants.eventBus.on<FEvent>().listen((event) {
      if (event.id.endsWith(hashCode.toString())) {
        showSnackBar(event.msg);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var progressWidget = Center(
      child: new Material(
        color: Colors.transparent,
        child: new Center(
          child: new SizedBox(
            width: 100.0,
            height: 100.0,
            child: new Container(
              decoration: ShapeDecoration(
                color: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new CircularProgressIndicator(),
                  new Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: new Text(
                      Strings.msg_loading,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return Scaffold(
        key: scaffoldkey,
        appBar: getAppBar(),
        body: ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (context, _saving, _) => ModalProgressHUD(
                color: Colors.black,
                dismissible: true,
                progressIndicator: progressWidget,
                child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.blueGrey,
                            Colors.black,
                          ]),
                    ),
                    child: getBody()),
                inAsyncCall: _saving)));
  }

  @override
  void dispose() {
    s_subscription.cancel();
    d_subscription.cancel();
    c_subscription.cancel();
    f_subscription.cancel();
    super.dispose();
  }
}
