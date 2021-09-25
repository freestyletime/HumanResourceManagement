import 'package:http/http.dart' as http;

class NetWork {
  static bool _debug = true;

  static String HOST = "http://127.0.0.1:8080";

  /* 基础GET请求 */
  static Future<String> get(String url, {Map<String, String> params}) async {
    getCommonHeader() {
      var header = {
        // 'content-type': 'application/json; charset=utf-8'
      };
      return header;
    }

    if (params != null && params.isNotEmpty) {
      StringBuffer sb = StringBuffer("?");
      params.forEach((key, value) {
        sb.write("$key" + "=" + "$value" + "&");
      });
      String paramStr = sb.toString();
      paramStr = paramStr.substring(0, paramStr.length - 1);
      url += paramStr;
    }
    http.Response res = await http.get(url, headers: getCommonHeader());
    if (_debug) {
      print('_____________________');
      print('|发起Get请求|');
      print('|请求URL：$url|');
      print('|返回数据：${res.headers}|');
      print('|返回数据：${res.body}|');
      print('|_____________________|');
    }
    return res.body;
  }

/* 基础POST请求 */
  static Future<String> post(String url, {Map<String, String> params}) async {
    getCommonHeader() {
      var header = {
        'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
      };
      return header;
    }

    http.Response res =
        await http.post(url, body: params, headers: getCommonHeader());
    if (_debug) {
      print('_____________________');
      print('|发起Post请求|');
      print('|请求URL：$url|');
      print('|请求数据：${params.toString()}|');
      print('|返回数据：${res.headers}|');
      print('|返回数据：${res.body}|');
      print('|_____________________|');
    }
    return res.body;
  }
}
