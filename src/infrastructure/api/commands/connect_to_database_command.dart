import 'package:postgres/postgres.dart';

import '../config/database_config.dart';
import '../exceptions/database_exception.dart';

abstract class ConnectToDatabaseCommand {
  static Future<Connection> connectToDatabase() async {
    try {
      return await Connection.open(DatabaseConfig.databaseConfig);
    } catch (exception, stackTrace) {
      throw DatabaseException(
        businessMessage: 'Failed to connect to the database.',
        technicalMessage: exception.toString(),
        stackTrace: stackTrace,
      );
    }
  }
}
