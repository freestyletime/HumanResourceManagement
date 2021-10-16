import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final String content;
  final String hint;
  final Function callback;

  SearchBox({this.content, this.hint, this.callback});

  Widget build(BuildContext context) {
    var controller = content == null
        ? null
        : TextEditingController.fromValue(TextEditingValue(
            text: content,
            selection: TextSelection.fromPosition(TextPosition(
                affinity: TextAffinity.downstream, offset: content.length))));

    return Card(
      margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
      ),
      child: Container(
        padding: EdgeInsets.only(left: 25.0, right: 25.0),
        height: 45.0,
        child: Center(
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(Icons.search, size: 20.0),
              ),
              Expanded(
                  child: TextField(
                controller: controller,
                keyboardType: TextInputType.text,
                maxLines: 1,
                decoration:
                    InputDecoration(border: InputBorder.none, hintText: hint),
                cursorColor: Colors.pink,
                onChanged: callback,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
