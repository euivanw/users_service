import 'dart:io';

import 'package:postgres/postgres.dart';

abstract class DatabaseConfig {
  static final databaseConfig = Endpoint(
    host: Platform.environment['DB_HOST'] as String,
    port: int.parse(Platform.environment['DB_PORT'] as String),
    database: Platform.environment['DB_NAME'] as String,
    username: Platform.environment['DB_USER'] as String,
    password: Platform.environment['DB_PASSWORD'] as String,
  );
}
