import 'package:bracket/plugins.dart';
import 'package:bracket/service/http_util.dart';

class Api {
  static Future index({Map<String, dynamic>? queryParameters}) {
    return HttpUtil().get('index', queryParameters: queryParameters);
  }

  static Future filmDetail({Map<String, dynamic>? queryParameters}) {
    return HttpUtil().get('filmDetail', queryParameters: queryParameters);
  }
}
