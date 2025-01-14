import 'package:agenciave_dash/core/exceptions/auth_exception.dart';
import 'package:agenciave_dash/core/fp/either.dart';
import 'package:agenciave_dash/core/fp/nil.dart';

abstract interface class SplashServices {
  Future<Either<AuthException, Nil>> checkAuth({required String apiKey});
}
