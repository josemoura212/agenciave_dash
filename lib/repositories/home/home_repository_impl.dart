import 'dart:developer';

import 'package:agenciave_dash/core/constants/local_storage_constants.dart';
import 'package:agenciave_dash/core/exceptions/repository_exception.dart';
import 'package:agenciave_dash/core/fp/either.dart';
import 'package:agenciave_dash/core/local_storage/local_storage.dart';
import 'package:agenciave_dash/core/rest_client/rest_client.dart';
import 'package:agenciave_dash/models/ads_model.dart';
import 'package:agenciave_dash/models/raw_sale_model.dart';
import 'package:agenciave_dash/modules/home/core/home_controller.dart';
import 'package:agenciave_dash/repositories/home/home_repository.dart';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeRepositoryImpl implements HomeRepository {
  final RestClient _restClient;
  final LocalStorage _localStorage;

  HomeRepositoryImpl({
    required RestClient restClient,
    required LocalStorage localStorage,
  })  : _restClient = restClient,
        _localStorage = localStorage;

  @override
  Future<Either<RepositoryException, List<RawSaleModel>>> getHomeData(
      Product product) async {
    final apiKey = await _localStorage.read(LocalStorageConstants.apiKey);
    final response = await _restClient.get("?name=${product.toString()}",
        options: Options(
          headers: {"x-api-key": apiKey},
        ));

    if (response.statusCode == 200) {
      final List<RawSaleModel> homeData = (response.data as List).map((e) {
        try {
          return RawSaleModel.fromMap(e);
        } catch (e) {
          return RawSaleModel.empty();
        }
      }).toList();

      log(homeData.toString());

      return Right(homeData);
    } else {
      return Left(RepositoryException(
        message: "Erro ao buscar dados",
      ));
    }
  }

  @override
  Future<Either<RepositoryException, List<AdsModel>>> getAdsData(
      Product product) async {
    final apiKey = await _localStorage.read(LocalStorageConstants.apiKey);
    final response = await _restClient.get("?name=ADS-${product.toString()}",
        options: Options(
          headers: {"x-api-key": apiKey},
        ));

    if (response.statusCode == 200) {
      if (response.data == null || response.data.isEmpty) {
        return Right([]);
      }
      final List<AdsModel> adsData = (response.data as List).map((e) {
        try {
          return AdsModel.fromMap(e);
        } catch (e) {
          return AdsModel.empty();
        }
      }).toList();

      log(adsData.toString());

      return Right(adsData);
    } else {
      return Left(RepositoryException(
        message: "Erro ao buscar dados",
      ));
    }
  }

  @override
  ({WebSocketChannel channel, Function dispose}) openChannelSocket() {
    final channel = WebSocketChannel.connect(
        Uri.parse("${LocalStorageConstants.baseUrlWs}/ws"));

    return (
      channel: channel,
      dispose: () {
        channel.sink.close();
      }
    );
  }
}
