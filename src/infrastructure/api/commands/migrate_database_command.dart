import 'dart:ffi' show Void;

import 'package:postgres/postgres.dart';

import '../../../usecase/migration/handle_migrate_table/handle_migrate_table_input_dto.dart';
import '../../../usecase/migration/handle_migrate_table/handle_migrate_table_usecase.dart';
import '../../../usecase/migration/migrate/migrate_input_dto.dart';
import '../../../usecase/migration/migrate/migrate_usecase.dart';
import '../../database/migration/migration_repository_impl.dart';
import '../config/migration_config.dart';
import '../exceptions/migration_exception.dart';

abstract class MigrateDatabaseCommand {
  static Future<void> migrateDatabase(Connection dbconn) async {
    final repository = MigrationRepositoryImpl(connection: dbconn);
    final usecase = HandleMigrateTableUsecase(repository: repository);
    final input = HandleMigrateTableInputDto();
    final migrationStatus = await usecase.execute(input);

    if (migrationStatus.isLeft) {
      migrationStatus.mapLeft((exception) {
        throw MigrationException(
          businessMessage: exception.businessMessage,
          technicalMessage: exception.technicalMessage,
          stackTrace: exception.stackTrace,
        );
      });
    }

    final migrateUsecase = MigrateUsecase(repository: repository);

    for (final migration in MigrationConfig.migrations) {
      final input = MigrateInputDto(
        id: migration.id,
        name: migration.name,
        sql: migration.sql,
      );

      final migrated = await migrateUsecase.execute(input);

      migrated.fold(
        ifLeft: (exception) {
          throw MigrationException(
            businessMessage: exception.businessMessage,
            technicalMessage: exception.technicalMessage,
            stackTrace: exception.stackTrace,
          );
        },
        ifRight: (migrationOutput) => Void,
      );
    }
  }
}
