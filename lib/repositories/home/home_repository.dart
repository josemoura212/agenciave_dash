import 'package:agenciave_dash/core/exceptions/auth_exception.dart';
import 'package:agenciave_dash/core/exceptions/repository_exception.dart';
import 'package:agenciave_dash/core/fp/either.dart';
import 'package:agenciave_dash/models/ads_model.dart';
import 'package:agenciave_dash/models/product_model.dart';
import 'package:agenciave_dash/models/raw_sale_model.dart';
import 'package:agenciave_dash/modules/home/core/home_controller.dart';

abstract interface class HomeRepository {
  Future<Either<AuthException, List<ProductModel>>> getProducts(
      {required String apiKey});
  Future<Either<RepositoryException, List<RawSaleModel>>> getHomeData(
      Product product);
  Future<Either<RepositoryException, List<AdsModel>>> getAdsData(
      Product product);
}
