import '/plugins.dart';
import '/service/http_util.dart';

class Api {
  static Future index(
      {required BuildContext context, Map<String, dynamic>? queryParameters}) {
    final data = context.read<VideoSourceStore>().data;
    final url = data?.actived ?? '';
    return HttpUtil()
        .get(context, '${url}index', queryParameters: queryParameters);
  }

  static Future filmDetail(
      {required BuildContext context, Map<String, dynamic>? queryParameters}) {
    final data = context.read<VideoSourceStore>().data;
    final url = data?.actived ?? '';
    return HttpUtil()
        .get(context, '${url}filmDetail', queryParameters: queryParameters);
  }

  static Future searchFilm(
      {required BuildContext context, Map<String, dynamic>? queryParameters}) {
    final data = context.read<VideoSourceStore>().data;
    final url = data?.actived ?? '';
    return HttpUtil()
        .get(context, '${url}searchFilm', queryParameters: queryParameters);
  }

  static Future filmClassifySearch(
      {required BuildContext context, Map<String, dynamic>? queryParameters}) {
    final data = context.read<VideoSourceStore>().data;
    final url = data?.actived ?? '';
    return HttpUtil().get(context, '${url}filmClassifySearch',
        queryParameters: queryParameters);
  }
}
