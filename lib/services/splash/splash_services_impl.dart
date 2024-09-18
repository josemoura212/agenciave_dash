import 'package:agenciave_dash/core/exceptions/auth_exception.dart';
import 'package:agenciave_dash/core/fp/either.dart';
import 'package:agenciave_dash/core/fp/nil.dart';
import 'package:agenciave_dash/repositories/splash/splash_repository.dart';
import 'package:agenciave_dash/services/splash/splash_services.dart';

class SplashServicesImpl implements SplashServices {
  final SplashRepository _splashRepository;

  SplashServicesImpl({
    required SplashRepository splashRepository,
  }) : _splashRepository = splashRepository;

  @override
  Future<Either<AuthException, Nil>> checkAuth({required String apiKey}) =>
      _splashRepository.checkAuth(apiKey: apiKey);
}
