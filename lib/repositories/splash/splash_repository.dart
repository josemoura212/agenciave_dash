import 'package:agenciave_dash/core/exceptions/auth_exception.dart';
import 'package:agenciave_dash/core/fp/either.dart';
import 'package:agenciave_dash/models/product_model.dart';

abstract interface class SplashRepository {
  Future<Either<AuthException, List<ProductModel>>> checkAuth(
      {required String apiKey});
}
