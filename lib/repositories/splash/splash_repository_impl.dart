import 'package:agenciave_dash/core/constants/local_storage_constants.dart';
import 'package:agenciave_dash/core/exceptions/auth_exception.dart';
import 'package:agenciave_dash/core/fp/either.dart';
import 'package:agenciave_dash/core/fp/nil.dart';
import 'package:agenciave_dash/core/rest_client/rest_client.dart';
import 'package:agenciave_dash/repositories/splash/splash_repository.dart';
import 'package:dio/dio.dart';

class SplashRepositoryImpl implements SplashRepository {
  final RestClient _restClient;

  SplashRepositoryImpl({required RestClient restClient})
      : _restClient = restClient;
  @override
  Future<Either<AuthException, Nil>> checkAuth({required String apiKey}) async {
    try {
      final response = await _restClient.unAuth.post(
        '${LocalStorageConstants.baseUrl}/webhook/dashboard',
        options: Options(
          headers: {"x-api-key": apiKey},
        ),
      );
      if (response.statusCode == 200) {
        return Right(nil);
      } else {
        return Left(AuthUnauthorizedException());
      }
    } catch (e) {
      return Left(AuthUnauthorizedException());
    }
  }
}
