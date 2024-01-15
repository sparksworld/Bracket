import 'package:bracket/service/http_util.dart';
import 'package:bracket/store/recommend/recommend.dart';

class Api {
  static Future index({Map<String, dynamic>? queryParameters}) {
    return HttpUtil().get('index', queryParameters: queryParameters);
  }
}
