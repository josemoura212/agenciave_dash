import 'package:agenciave_dash/core/exceptions/auth_exception.dart';
import 'package:agenciave_dash/core/exceptions/repository_exception.dart';
import 'package:agenciave_dash/core/fp/either.dart';
import 'package:agenciave_dash/models/ads_model.dart';
import 'package:agenciave_dash/models/product_model.dart';
import 'package:agenciave_dash/models/raw_sale_model.dart';
import 'package:agenciave_dash/modules/home/core/home_controller.dart';
import 'package:agenciave_dash/repositories/home/home_repository.dart';
import 'package:agenciave_dash/services/home/home_services.dart';

class HomeServicesImpl implements HomeServices {
  final HomeRepository _homeRepository;

  HomeServicesImpl({required HomeRepository homeRepository})
      : _homeRepository = homeRepository;

  @override
  Future<Either<RepositoryException, List<RawSaleModel>>> getHomeData(
          Product product) =>
      _homeRepository.getHomeData(product);

  @override
  Future<Either<RepositoryException, List<AdsModel>>> getAdsData(
          Product product) =>
      _homeRepository.getAdsData(product);

  @override
  Future<Either<AuthException, List<ProductModel>>> getProducts(
          {required String apiKey}) =>
      _homeRepository.getProducts(apiKey: apiKey);
}
