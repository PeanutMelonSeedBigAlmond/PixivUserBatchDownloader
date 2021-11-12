import 'package:dio_http/dio_http.dart';

import '/config.dart';

class MyInterceptor extends InterceptorsWrapper{
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var needCookie=options.extra["needCookie"]==true;
    if(needCookie){
      options.headers["cookie"]=cookie;
    }
    return handler.next(options);
  }
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }
}