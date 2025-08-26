// services/base_service.dart
import 'package:you_owe_us/app_config.dart';

class BaseService {
  final AppConfig config;
  BaseService(this.config);

  String get baseUrl => config.endpointUrl();
}
