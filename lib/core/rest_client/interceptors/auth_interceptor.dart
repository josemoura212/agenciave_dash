import 'package:agenciave_dash/core/constants/local_storage_constants.dart';
import 'package:dio/dio.dart';
import "package:shared_preferences/shared_preferences.dart";

final class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final RequestOptions(:headers, :extra) = options;
    const authHeaderKey = "Authorization";

    headers.remove(authHeaderKey);

    if (extra case {"DIO_AUTH_KEY": true}) {
      final sp = await SharedPreferences.getInstance();
      headers.addAll(
        {authHeaderKey: "${sp.getString(LocalStorageConstants.accessToken)}"},
      );
    }
    handler.next(options);
    super.onRequest(options, handler);
  }
}
