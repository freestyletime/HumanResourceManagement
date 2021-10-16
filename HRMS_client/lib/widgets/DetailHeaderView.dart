import 'package:flutter/material.dart';

class DetailHeaderView extends StatelessWidget {
  final String id;
  final String name;
  final String other;

  const DetailHeaderView(
      {Key key, @required this.id, @required this.name, this.other})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widgets = List<Widget>();
    widgets.add(Text('#' + id + '  ' + name,
        style: TextStyle(
          color: Colors.deepOrange,
          fontSize: 30,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        )));
    if (this.other != null && this.other.isNotEmpty) {
      widgets.add(Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            other,
            style: TextStyle(color: Colors.yellow, fontSize: 16),
          )));
    }

    return Container(
        padding: EdgeInsets.only(left: 15, top: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        ));
  }
}
