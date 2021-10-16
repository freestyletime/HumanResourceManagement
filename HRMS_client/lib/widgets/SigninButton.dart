import 'package:flutter/material.dart';

class SigninButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final double height;
  final Function onPressed;

  const SigninButton({
    Key key,
    @required this.child,
    this.gradient,
    this.width = double.infinity,
    this.height = 50.0,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var radius = BorderRadius.circular(25.0);
    return Container(
      width: width,
      height: 45.0,
      decoration: BoxDecoration(
          borderRadius: radius,
          gradient: LinearGradient(
            colors: <Color>[Colors.blueGrey, Colors.orange],
          )),
      child: Material(
        elevation: 10,
        borderRadius: radius,
        color: Colors.transparent,
        child: InkWell(
            borderRadius: radius,
            onTap: onPressed,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}
