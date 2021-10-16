import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';

// 对话框工具类
abstract class DialogUtils {
  // 显示默认弹窗
  static void alert(context, {@required String text, String title, String yes, Function yesCallBack}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        child: AlertDialog(
          title: Text(title == null ? Strings.msg_prompt : title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(yes == null ? Strings.msg_confirm : yes),
              onPressed: () {
                if (yesCallBack != null) yesCallBack();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(Strings.msg_cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }
}