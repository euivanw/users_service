import 'dart:io';

import 'package:shelf_router/shelf_router.dart';

class ServerInstance {
  static final String contentType = 'application/json; charset=utf-8';

  final Router _app;
  final int _port;
  final String _apiVersion;

  ServerInstance()
    : _app = Router(),
      _port = int.parse(Platform.environment['SERVER_PORT'] as String),
      _apiVersion = 'v1';

  Router get app => _app;

  int get port => _port;

  String get apiVersion => _apiVersion;
}
