import 'package:flutter/material.dart';
import 'package:flutter_hrms/pages/HomePage.dart';
import 'Constants.dart';

import 'events/ThemeEvent.dart';
import 'pages/LoginPage.dart';

void main() => runApp(FlutterHRMS());

class FlutterHRMS extends StatefulWidget {
  @override
  _FlutterHRMSState createState() => _FlutterHRMSState();
}

class _FlutterHRMSState extends State<FlutterHRMS> {
  @override
  void initState() {
    super.initState();
    Constants.eventBus.on<ThemeEvent>().listen((event) {
      setState(() {
        //TODO 应该添加至SP中持久化，待下次进入时使用
        Constants.currentTheme = event.themeModel;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Constants.currentTheme == Constants.dayTheme
        ? ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.blue,
            accentColor: Colors.orangeAccent)
        : ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.black,
            accentColor: Colors.cyan);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      routes:  <String, WidgetBuilder> {
        LoginPage.tag: (_) => new LoginPage(),
        HomePage.tag: (_) => new HomePage()
      },
      home: LoginPage(),
    );
  }
}

