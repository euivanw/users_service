import 'package:dart_either/dart_either.dart' show Either, Left, Right;
import 'package:logging/logging.dart';

import '../../../domain/migration/migration_exception.dart';
import '../../../domain/migration/migration_repository.dart';
import '../../shared/usecase.dart';
import 'migrate_input_dto.dart';
import 'migrate_output_dto.dart';
import 'migrate_type.dart';

final class MigrateUsecase
    implements Usecase<MigrateInputDto, MigrateOutputDto, MigrationException> {
  final Logger _logger;
  final MigrationRepository _repository;

  MigrateUsecase({required MigrationRepository repository})
    : _repository = repository,
      _logger = Logger('MigrateUsecase');

  @override
  Future<Either<MigrationException, MigrateOutputDto>> execute(
    MigrateInputDto input,
  ) async {
    try {
      final exists = await _repository.checkMigrationExists(input.id);

      if (exists) {
        return Right(MigrateOutputDto(type: MigrateType.unchanged));
      }

      await _repository.migrate(id: input.id, name: input.name, sql: input.sql);

      _logger.info('Migration [${input.name}] executed successfully.');

      return Right(MigrateOutputDto(type: MigrateType.added));
    } on MigrationException catch (e) {
      return Left(e);
    } catch (exception, stackTrace) {
      return Left(
        MigrationException(
          businessMessage: 'An unexpected error occurred while migrating.',
          technicalMessage: exception.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
