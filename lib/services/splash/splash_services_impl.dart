import 'package:agenciave_dash/core/auth/auth_controller.dart';
import 'package:agenciave_dash/core/exceptions/auth_exception.dart';
import 'package:agenciave_dash/core/fp/either.dart';
import 'package:agenciave_dash/core/fp/nil.dart';
import 'package:agenciave_dash/repositories/splash/splash_repository.dart';
import 'package:agenciave_dash/services/splash/splash_services.dart';

class SplashServicesImpl implements SplashServices {
  final SplashRepository _splashRepository;
  final AuthController _authController;

  SplashServicesImpl({
    required SplashRepository splashRepository,
    required AuthController authController,
  })  : _splashRepository = splashRepository,
        _authController = authController;

  @override
  Future<Either<AuthException, Nil>> checkAuth({required String apiKey}) async {
    await _splashRepository.checkAuth(apiKey: apiKey);
    _authController.setAuthenticate(apiKey);

    return Right(Nil());
  }
}
