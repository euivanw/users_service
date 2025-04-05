import 'package:postgres/postgres.dart';

abstract class DatabaseConfig {
  static final databaseConfig = Endpoint(
    host: String.fromEnvironment('DB_HOST'),
    port: int.fromEnvironment('DB_PORT'),
    database: String.fromEnvironment('DB_DATABASE'),
    username: String.fromEnvironment('DB_USER'),
    password: String.fromEnvironment('DB_PASSWORD'),
  );
}
