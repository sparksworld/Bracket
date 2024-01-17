import 'package:bracket/plugins.dart';
import 'package:dio/dio.dart';

class HttpUtil {
  static final HttpUtil _instance = HttpUtil._internal();
  factory HttpUtil() => _instance;
  static HttpUtil get instance => _instance;

  late Dio _dio;

  HttpUtil._internal() {
    BaseOptions options = BaseOptions();
    options.baseUrl = "http://film.fe-spark.cn/api/";
    options.connectTimeout = const Duration(seconds: 5);
    options.receiveTimeout = const Duration(seconds: 5);
    options.contentType = 'application/json; charset=utf-8';
    options.responseType = ResponseType.json;

    _dio = Dio(options);

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Do something before request is sent
        return handler.next(options); //continue
      },
      onResponse: (response, handler) {
        // Do something with response data
        return handler.next(response); // continue
      },
      // onError: (DioError e, handler) {
      //   ErrorEntity eInfo = createErrorEntity(e);
      //   onError(eInfo);
      //   return handler.next(e); //continue
      // },
    ));
  }
  // 请求(默认post)
  Future _request(String url,
      {String method = "post", Map<String, dynamic>? params}) async {
    Options options = Options(method: method);
    try {
      final result =
          await _dio.request(url, queryParameters: params, options: options);

      return result;
    } on DioException catch (error) {
      print(error);
    }
  }

  Future<T> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? requestOptions,
  }) async {
    var response = await _request(url, method: "get", params: queryParameters);
    print(response);
    return response?.data;
  }

  Future<T> post<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? requestOptions,
  }) async {
    var response = await _request(url, method: "post", params: queryParameters);
    print(response);
    return response?.data;
  }
}
