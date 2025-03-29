import 'package:postgres/postgres.dart';
import 'package:uuid/uuid_value.dart';

import '../../../domain/migration/migration_exception.dart';
import '../../../domain/migration/migration_repository.dart';
import '../../../shared/string_extension.dart';

class MigrationRepositoryImpl implements MigrationRepository {
  final Connection _connection;

  const MigrationRepositoryImpl({required Connection connection})
    : _connection = connection;

  @override
  Future<bool> checkMigrationExists(UuidValue id) async {
    try {
      final result = await _connection.execute(
        Sql.named('''
          SELECT  id
          FROM    migration
          WHERE   id = @id
        '''),
        parameters: {'id': id.uuid},
      );

      return result.isNotEmpty;
    } catch (exception, stackTrace) {
      throw MigrationException(
        businessMessage:
            'Failed to check migration with ID [${id.uuid}]. Please try again.',
        technicalMessage: 'Unknown error: $exception',
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<bool> migrate({
    required UuidValue id,
    required String name,
    required String sql,
  }) async {
    try {
      await _connection.execute(sql);

      await _connection.execute(
        Sql.named('''
          INSERT INTO migration (
            id, 
            name, 
            sql
          ) VALUES (
            @id,
            @name,
            @sql
          )
        '''),
        parameters: {'id': id.uuid, 'name': name.trim(), 'sql': sql.formatText},
      );

      return true;
    } catch (exception, stackTrace) {
      throw MigrationException(
        businessMessage:
            'Failed to migrate with ID [${id.uuid}]. Please try again.',
        technicalMessage: 'Unknown error: $exception',
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<bool> checkMigrationTableExists() async {
    try {
      final result = await _connection.execute('''
        SELECT  table_name
        FROM    information_schema.tables 
        WHERE   table_schema = 'public' 
        AND     table_name = 'migration'
      ''');

      return result.isNotEmpty;
    } catch (exception, stackTrace) {
      throw MigrationException(
        businessMessage:
            'Failed to check whether migration table exists or not. Please try again.',
        technicalMessage: 'Unknown error: $exception',
        stackTrace: stackTrace,
      );
    }
  }
}
