import 'package:agenciave_dash/core/constants/local_storage_constants.dart';
import 'package:agenciave_dash/core/rest_client/rest_client.dart';
import 'package:flutter_getit/flutter_getit.dart';

class DashApplicationBindins extends ApplicationBindings {
  @override
  List<Bind<Object>> bindings() => [
        Bind.lazySingleton((i) => RestClient(LocalStorageConstants.baseUrl)),
      ];
}
