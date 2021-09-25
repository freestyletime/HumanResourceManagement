import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static final String tag = 'home-page';

  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: new Text(''),
    );
  }
}