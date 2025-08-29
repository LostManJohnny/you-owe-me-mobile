import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppConfig {
  final String? env;
  final String appName = 'You Owe Me';

  AppConfig(this.env);

  static load() async {
    // Load .env (so ENV is available)
    await dotenv.load(fileName: '.env', isOptional: false);
    return AppConfig(dotenv.env['ENV']);
  }

  bool isDev() => env == null || env!.toLowerCase() == 'dev';

  bool isTest() => env?.toLowerCase() == 'test';

  bool isLive() => env?.toLowerCase() == 'live';

  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();

  String endpointUrl() {
    var url = 'http://127.0.0.1:8000';
    if (isTest()) url = 'https://test.api.com';
    if (isLive()) url = 'https://live.api.com';
    return url;
  }
}
