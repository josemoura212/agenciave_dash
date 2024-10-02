import 'package:agenciave_dash/core/exceptions/repository_exception.dart';
import 'package:agenciave_dash/core/fp/either.dart';
import 'package:agenciave_dash/models/home_model.dart';
import 'package:agenciave_dash/modules/home/core/home_controller.dart';
import 'package:agenciave_dash/repositories/home/home_repository.dart';
import 'package:agenciave_dash/services/home/home_services.dart';

class HomeServicesImpl implements HomeServices {
  final HomeRepository _homeRepository;

  HomeServicesImpl({required HomeRepository homeRepository})
      : _homeRepository = homeRepository;

  @override
  Future<Either<RepositoryException, List<HomeModel>>> getHomeData(
          Product product) =>
      _homeRepository.getHomeData(product);
}
