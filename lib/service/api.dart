import 'package:bracket/plugins.dart';
import 'package:bracket/service/http_util.dart';

class Api {
  static Future index({Map<String, dynamic>? queryParameters}) {
    return HttpUtil().get('index', queryParameters: queryParameters);
  }
}
