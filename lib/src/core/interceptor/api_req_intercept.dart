import 'package:dio/dio.dart';

class ApiReqIntercept extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.baseUrl = 'http://fake-api.tractian.com';
    options.headers.addAll({
      'Content-Type': 'application/json',
    });

    super.onRequest(options, handler);
  }
}
