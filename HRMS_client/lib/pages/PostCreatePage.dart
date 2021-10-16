import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/IModel.dart';
import 'package:flutter_hrms/pages/BasePage.dart';

class PostCreatePage extends StatefulWidget {
  @override
  _PostCreatePageState createState() => _PostCreatePageState();
}

class _PostCreatePageState extends BasePageState<PostCreatePage> {
  // 统一风格
  var style = TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0);
  // 职位姓名
  String _name;
  // 职位描述
  String _description = '';
  // 职级
  var _level = ValueNotifier<String>(Constants.POST_LEVEL_P1);

  void _submit() {
    if (_name == null) {
      showSnackBar(Strings.msg_key_empty);
      return;
    }

    service.getPostAPI().addPost(
          Ids.ID_ADD_POST + hashCode.toString(),
          _name,
          _level.value,
          _description,
        );
  }

  Widget _getOrdinaryInputWidget(int maxLength, String content, String label,
      String hint, Function result) {
    return TextField(
        controller: TextEditingController(text: content),
        maxLength: maxLength,
        decoration: InputDecoration(
          labelStyle: style,
          hintText: hint,
          labelText: label,
        ),
        onChanged: result);
  }

  @override
  AppBar getAppBar() {
    return AppBar(
        centerTitle: true,
        title: Text(Strings.post_menu_add),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.done_all),
              onPressed: (() {
                if (!isLoading.value) _submit();
              })),
        ]);
  }

  @override
  Widget getBody() {
    var gap = SizedBox(height: 10);

    // 职级数据
    var _levelDatas = <String>[
      Constants.POST_LEVEL_P1,
      Constants.POST_LEVEL_P2,
      Constants.POST_LEVEL_P3,
      Constants.POST_LEVEL_P4,
      Constants.POST_LEVEL_P5,
      Constants.POST_LEVEL_P6,
      Constants.POST_LEVEL_P7
    ].map<DropdownMenuItem<String>>((String val) {
      return DropdownMenuItem<String>(
        value: val,
        child: Text(val),
      );
    }).toList();

    var nameWidget = _getOrdinaryInputWidget(
      20,
      _name,
      Strings.post_info_name,
      Strings.post_info_name_hint,
      (val) => val.isEmpty ? _name = '' : _name = val,
    );

    var descriptionWidget = _getOrdinaryInputWidget(
      100,
      _description,
      Strings.post_info_description,
      Strings.post_info_description_hint,
      (val) => val.isEmpty ? _description = '' : _description = val,
    );

    var levelWidget = ValueListenableBuilder(
        valueListenable: _level,
        builder: (context, level, _) {
          return Container(
              margin: EdgeInsets.only(left: 15),
              child: DropdownButton<String>(
                elevation: 10,
                underline: SizedBox(),
                value: level,
                onChanged: (String level) {
                  _level.value = level;
                },
                items: _levelDatas,
              ));
        });

    return ListView(padding: EdgeInsets.all(15.0), children: <Widget>[
      nameWidget,
      gap,
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(Strings.post_info_level + ':  ', style: style),
          levelWidget,
        ],
      ),
      gap,
      descriptionWidget,
    ]);
  }

  @override
  void success<E extends IModel>(String id, E t) {
    if (Ids.ID_ADD_POST + hashCode.toString() == id && t is IModel) {
      if (Constants.STATUS_SUCCESS == t.status) {
        Navigator.pop<String>(context, Strings.post_add_success);
      }
    }
  }
}
