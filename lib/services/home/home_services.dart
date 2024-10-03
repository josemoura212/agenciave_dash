import 'package:agenciave_dash/core/exceptions/repository_exception.dart';
import 'package:agenciave_dash/core/fp/either.dart';
import 'package:agenciave_dash/models/raw_sale_model.dart';
import 'package:agenciave_dash/modules/home/core/home_controller.dart';

abstract interface class HomeServices {
  Future<Either<RepositoryException, List<RawSaleModel>>> getHomeData(
      Product product);
}
