import 'package:agenciave_dash/core/constants/local_storage_constants.dart';
import 'package:agenciave_dash/core/exceptions/auth_exception.dart';
import 'package:agenciave_dash/core/fp/either.dart';
import 'package:agenciave_dash/core/fp/nil.dart';
import 'package:agenciave_dash/core/local_storage/local_storage.dart';
import 'package:agenciave_dash/repositories/splash/splash_repository.dart';
import 'package:agenciave_dash/services/splash/splash_services.dart';

class SplashServicesImpl implements SplashServices {
  final SplashRepository _splashRepository;
  final LocalStorage _localStorage;

  SplashServicesImpl({
    required SplashRepository splashRepository,
    required LocalStorage localStorage,
  })  : _splashRepository = splashRepository,
        _localStorage = localStorage;

  @override
  Future<Either<AuthException, Nil>> checkAuth({required String apiKey}) async {
    await _splashRepository.checkAuth(apiKey: apiKey);
    _localStorage.write(LocalStorageConstants.apiKey, apiKey);

    return Right(Nil());
  }
}
