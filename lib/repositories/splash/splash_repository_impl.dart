import 'dart:developer';

import 'package:agenciave_dash/core/exceptions/auth_exception.dart';
import 'package:agenciave_dash/core/fp/either.dart';
import 'package:agenciave_dash/core/fp/nil.dart';
import 'package:agenciave_dash/core/rest_client/rest_client.dart';
import 'package:agenciave_dash/repositories/splash/splash_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SplashRepositoryImpl implements SplashRepository {
  final RestClient _restClient;

  SplashRepositoryImpl({required RestClient restClient})
      : _restClient = restClient;
  @override
  Future<Either<AuthException, Nil>> checkAuth({required String apiKey}) async {
    try {
      final response = await _restClient.post(
        dotenv.env['BASE_URL']!,
        options: Options(
          headers: {"x-api-key": apiKey},
        ),
      );
      if (response.statusCode == 200) {
        return Right(nil);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        log("Erro 401 ou 403  1");
        return Left(AuthUnauthorizedException());
      } else {
        log("Erro 401 ou 403  2");
        return Left(AuthUnauthorizedException());
      }
    } catch (e) {
      log("Erro 401 ou 403   3");
      return Left(AuthUnauthorizedException());
    }
  }
}
