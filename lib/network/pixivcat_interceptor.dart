import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

class PixivCatInterceptor extends QueuedInterceptorsWrapper {
  static Dio? _dio = null;

  static const _HOST = "https://i.pixiv.re/";

  void _makeSureDioInitialized() {
    if (_dio == null) {
      var options = BaseOptions(baseUrl: _HOST);
      _dio = Dio(options);
    }
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final requestUri = options.uri;
    if (requestUri.host.contains("i.pximg.net")) {
      _makeSureDioInitialized();
      final path = options.uri.path;
      final method = options.method;
      final headers = options.headers..remove("host")..remove("referer");
      return handler.resolve(
          await _dio!.request(
              path,
              options: Options(
                  responseType: options.responseType,
                  method: method,
                  headers: headers)
          )
      );
    }
    return handler.next(options);
  }
}
