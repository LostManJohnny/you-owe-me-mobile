// services/base_web_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:you_owe_us/app_config.dart';

class BaseWebService {
  final AppConfig config;
  final GoRouter router; // <-- injected
  static const _defaultTimeOut = 60;

  BaseWebService(this.config, this.router);

  String get baseUrl => config.endpointUrl();

  Future<dynamic> getJsonResponse(String urlString, {int timeoutSeconds = _defaultTimeOut, int retries = 1}) async {
    final uri = Uri.parse(Uri.encodeFull('$baseUrl/$urlString'));
    final headers = await getHeaders();
    final r = RetryOptions(maxAttempts: retries + 1);

    late http.Response result;
    try {
      result = await r.retry(
        () => http.get(uri, headers: headers).timeout(Duration(seconds: timeoutSeconds)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
    } on TimeoutException {
      throw TimeoutException('Server connection exceeded timeout $timeoutSeconds');
    } on SocketException {
      throw SocketException('We are unable to connect to the server, please check your network connection');
    } catch (e) {
      if (kDebugMode) print(e);
      rethrow;
    }

    if (kDebugMode) {
      print('request status: ${result.statusCode}: ${result.reasonPhrase}');
    }

    try {
      _validateResponse(result, uri: uri.path);
    } on HttpRefreshTokenException {
      return await getJsonResponse(urlString, timeoutSeconds: timeoutSeconds, retries: retries);
    }

    return result.body;
  }

  Future<dynamic> postJson(
    String urlString, {
    Object? body,
    int timeoutSeconds = _defaultTimeOut,
    int retries = 1,
    Map<String, String>? extraHeaders,
  }) async {
    final uri = Uri.parse(Uri.encodeFull('$baseUrl/$urlString'));
    final headers = {
      ...await getHeaders(),
      if (extraHeaders != null) ...extraHeaders,
    };

    // If the body is a Map/List and caller didn't provide a raw string,
    // encode as JSON and ensure Content-Type header.
    Object? payload = body;
    if (body != null && body is! String && body is! List<int>) {
      headers['Content-Type'] = headers['Content-Type'] ?? 'application/json';
      payload = jsonEncode(body);
    }

    final r = RetryOptions(maxAttempts: retries + 1);
    late http.Response result;

    try {
      result = await r.retry(
        () => http.post(uri, headers: headers, body: payload).timeout(Duration(seconds: timeoutSeconds)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
    } on TimeoutException {
      throw TimeoutException('Server connection exceeded timeout $timeoutSeconds');
    } on SocketException {
      throw SocketException('We are unable to connect to the server, please check your network connection');
    } catch (e) {
      if (kDebugMode) print(e);
      rethrow;
    }

    if (kDebugMode) {
      print('request status: ${result.statusCode}: ${result.reasonPhrase}');
    }

    try {
      _validateResponse(result, uri: uri.path);
    } on HttpRefreshTokenException {
      return await postJson(
        urlString,
        body: body,
        timeoutSeconds: timeoutSeconds,
        retries: retries,
        extraHeaders: extraHeaders,
      );
    }

    return result.body;
  }

  Future<dynamic> putJson(
    String urlString, {
    Object? body,
    int timeoutSeconds = _defaultTimeOut,
    int retries = 1,
    Map<String, String>? extraHeaders,
  }) async {
    final uri = Uri.parse(Uri.encodeFull('$baseUrl/$urlString'));
    final headers = {
      ...await getHeaders(),
      if (extraHeaders != null) ...extraHeaders,
    };

    Object? payload = body;
    if (body != null && body is! String && body is! List<int>) {
      headers['Content-Type'] = headers['Content-Type'] ?? 'application/json';
      payload = jsonEncode(body);
    }

    final r = RetryOptions(maxAttempts: retries + 1);
    late http.Response result;

    try {
      result = await r.retry(
        () => http.put(uri, headers: headers, body: payload).timeout(Duration(seconds: timeoutSeconds)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
    } on TimeoutException {
      throw TimeoutException('Server connection exceeded timeout $timeoutSeconds');
    } on SocketException {
      throw SocketException('We are unable to connect to the server, please check your network connection');
    } catch (e) {
      if (kDebugMode) print(e);
      rethrow;
    }

    if (kDebugMode) {
      print('request status: ${result.statusCode}: ${result.reasonPhrase}');
    }

    try {
      _validateResponse(result, uri: uri.path);
    } on HttpRefreshTokenException {
      return await putJson(
        urlString,
        body: body,
        timeoutSeconds: timeoutSeconds,
        retries: retries,
        extraHeaders: extraHeaders,
      );
    }

    return result.body;
  }

  Future<dynamic> deleteJson(
    String urlString, {
    Object? body, // some APIs accept a body with DELETE
    int timeoutSeconds = _defaultTimeOut,
    int retries = 1,
    Map<String, String>? extraHeaders,
  }) async {
    final uri = Uri.parse(Uri.encodeFull('$baseUrl/$urlString'));
    final headers = {
      ...await getHeaders(),
      if (extraHeaders != null) ...extraHeaders,
    };

    Object? payload = body;
    if (body != null && body is! String && body is! List<int>) {
      headers['Content-Type'] = headers['Content-Type'] ?? 'application/json';
      payload = jsonEncode(body);
    }

    final r = RetryOptions(maxAttempts: retries + 1);
    late http.Response result;

    try {
      result = await r.retry(
        // http.delete supports a body in recent versions of package:http
        () => http.delete(uri, headers: headers, body: payload).timeout(Duration(seconds: timeoutSeconds)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
    } on TimeoutException {
      throw TimeoutException('Server connection exceeded timeout $timeoutSeconds');
    } on SocketException {
      throw SocketException('We are unable to connect to the server, please check your network connection');
    } catch (e) {
      if (kDebugMode) print(e);
      rethrow;
    }

    if (kDebugMode) {
      print('request status: ${result.statusCode}: ${result.reasonPhrase}');
    }

    try {
      _validateResponse(result, uri: uri.path);
    } on HttpRefreshTokenException {
      return await deleteJson(
        urlString,
        body: body,
        timeoutSeconds: timeoutSeconds,
        retries: retries,
        extraHeaders: extraHeaders,
      );
    }

    return result.body;
  }

  void _validateResponse(http.Response result, {String? uri}) {
    if (result.statusCode == 401) {
      const key = 'www-authenticate';
      if (result.headers.containsKey(key) && result.headers[key]?.contains('Bearer') == true) {
        throw HttpRefreshTokenException();
      }
    }
    if (result.statusCode == 403) {
      router.goNamed('login', extra: {'clientOutOfDate': true});
      return;
    }
    final ok = result.statusCode >= 200 && result.statusCode <= 299;
    if (!ok) {
      throw HttpException(result.reasonPhrase ?? '', uri: uri != null ? Uri.parse(uri) : null);
    }
  }

  Future<Map<String, String>> getHeaders() async => {'Content-Type': 'application/json'};
}

class HttpRefreshTokenException {}
