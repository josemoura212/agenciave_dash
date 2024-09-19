import 'package:agenciave_dash/core/exceptions/repository_exception.dart';
import 'package:agenciave_dash/core/fp/either.dart';
import 'package:agenciave_dash/models/home_model.dart';

abstract interface class HomeServices {
  Future<Either<RepositoryException, List<HomeModel>>> getHomeData();
}
