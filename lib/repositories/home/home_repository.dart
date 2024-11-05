import 'package:agenciave_dash/core/exceptions/repository_exception.dart';
import 'package:agenciave_dash/core/fp/either.dart';
import 'package:agenciave_dash/models/ads_model.dart';
import 'package:agenciave_dash/models/raw_sale_model.dart';
import 'package:agenciave_dash/modules/home/core/home_controller.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract interface class HomeRepository {
  Future<Either<RepositoryException, List<RawSaleModel>>> getHomeData(
      Product product);
  Future<Either<RepositoryException, List<AdsModel>>> getAdsData(
      Product product);
  ({WebSocketChannel channel, Function dispose}) openChannelSocket();
}
