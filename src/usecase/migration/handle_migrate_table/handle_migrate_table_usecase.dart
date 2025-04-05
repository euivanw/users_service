import 'package:dart_either/dart_either.dart' show Either, Right, Left;
import 'package:uuid/uuid.dart';

import '../../../domain/migration/migration_exception.dart';
import '../../../domain/migration/migration_repository.dart';
import '../../shared/usecase.dart';
import 'handle_migrate_table_input_dto.dart';
import 'handle_migrate_table_output_dto.dart';

final class HandleMigrateTableUsecase
    implements
        Usecase<
          HandleMigrateTableInputDto,
          HandleMigrateTableOutputDto,
          MigrationException
        > {
  final MigrationRepository _repository;

  const HandleMigrateTableUsecase({required MigrationRepository repository})
    : _repository = repository;

  @override
  Future<Either<MigrationException, HandleMigrateTableOutputDto>> execute(
    HandleMigrateTableInputDto input,
  ) async {
    try {
      final exists = await _repository.checkMigrationTableExists();

      if (!exists) {
        await _repository.migrate(
          id: UuidValue.fromString('bb438cdb-9878-4732-bec5-fd2d034f8d25'),
          name: 'Create migration table',
          sql: '''
            CREATE TABLE IF NOT EXISTS migration (
              id UUID PRIMARY KEY,
              name VARCHAR(150) NOT NULL,
              sql TEXT NOT NULL,
              migrated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );
          ''',
        );
      }

      return Right(HandleMigrateTableOutputDto());
    } on MigrationException catch (e) {
      return Left(e);
    } catch (exception, stackTrace) {
      return Left(
        MigrationException(
          businessMessage:
              'An unexpected error occurred while creating the migration table.',
          technicalMessage: exception.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
