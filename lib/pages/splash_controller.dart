import 'package:agenciave_dash/core/helpers/messages.dart';
import 'package:agenciave_dash/core/local_storage/local_storage.dart';
import 'package:agenciave_dash/core/rest_client/rest_client.dart';

class SplashController with MessageStateMixin {
  final RestClient _restClient;
  final LocalStorage _localStorage;

  SplashController({
    required RestClient restClient,
    required LocalStorage localStorage,
  })  : _restClient = restClient,
        _localStorage = localStorage;
}
