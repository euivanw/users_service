import 'dart:io';

import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';

import '../../shared/core_exception.dart';
import 'commands/configure_logging_command.dart';
import 'commands/connect_to_database_command.dart';
import 'commands/migrate_database_command.dart';
import 'commands/server_command.dart';

Future<void> main() async {
  final log = Logger('main');

  try {
    ConfigureLoggingCommand.configureLogging();

    log.info('Connecting to the database...');
    Connection dbconn = await ConnectToDatabaseCommand.connectToDatabase();
    log.info('Database connected successfully.');

    log.info('Migrating the database..');
    await MigrateDatabaseCommand.migrateDatabase(dbconn);
    log.info('Database migrated successfully.');

    final server = await ServerCommand.startServer(dbconn);
    log.info('Server listening on port ${server.port}.');
  } on CoreException catch (exception, stackTrace) {
    log.severe(exception.businessMessage, exception, stackTrace);
    exit(1);
  } catch (exception, stackTrace) {
    log.severe('An unknown error occurred.', exception, stackTrace);
    exit(1);
  }
}
