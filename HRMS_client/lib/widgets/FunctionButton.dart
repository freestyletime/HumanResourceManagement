import 'package:flutter/material.dart';

class FunctionButton extends StatelessWidget {
  final Color start;
  final Color end;
  final IconData icon;
  final String model;
  final TextStyle style;
  final Function fun;

  const FunctionButton(this.icon, this.model,
      {Key key, this.start, this.end, this.style, this.fun})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [start, end]),
      ),
      child: RaisedButton(
        color: Colors.transparent,
        elevation: 0,
        highlightElevation: 0,
        splashColor: Colors.grey,
        onPressed: () {
          if (fun != null) fun();
        },
        child: Container(
          alignment: Alignment.centerLeft,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(icon, size: 30),
                SizedBox(width: 7),
                Text(
                  model,
                  style: style,
                ),
              ]),
        ),
      ),
    );
  }
}
