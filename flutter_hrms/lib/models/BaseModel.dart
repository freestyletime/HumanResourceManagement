import 'IModel.dart';
import 'IBean.dart';

class BaseModel<T extends IBean> extends IModel {
  
  List<T> data;

  BaseModel(int status, String msg, List<T> data, String code): this.data=data, super(status, msg, code);

  BaseModel.fromJson(Map<String, dynamic> json, T t) : super.fromJson(json) {
    if (json['data'] != null) {
      data = new List<T>();
      json['data'].forEach((v) {
        data.add(t.fromJson(v));
      });
    }
  }
}
