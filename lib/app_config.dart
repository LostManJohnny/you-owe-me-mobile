class AppConfig {
  final String? env;

  // 👇 make this public instead of private
  AppConfig(this.env);

  bool isDev() => env == null || env!.toLowerCase() == 'dev';
  bool isTest() => env?.toLowerCase() == 'test';
  bool isLive() => env?.toLowerCase() == 'live';

  String endpointUrl() {
    var url = 'http://127.0.0.1:8000';
    if (isTest()) url = 'https://test.api.com';
    if (isLive()) url = 'https://live.api.com';
    return url;
  }
}
