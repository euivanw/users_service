import 'dart:io';

import 'package:postgres/postgres.dart';
import 'package:shelf/shelf_io.dart' as io;

import '../routers/main/main_routes.dart';
import '../routers/server_instance.dart';

class ServerCommand {
  static Future<HttpServer> startServer(Connection dbconn) async {
    final instance = ServerInstance();

    MainRoutes(instance: instance).configure();

    return await io.serve(instance.app.call, '0.0.0.0', instance.port);
  }
}
