// APP实体类型约束
class IModel {
  
  int status;
  String msg;
  String code;

  IModel(int status, String msg, String code)
      : this.status = status,
        this.msg = msg,
        this.code = code;

  IModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    msg = json['msg'];
  }
}
