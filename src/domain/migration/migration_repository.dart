import 'package:uuid/uuid.dart';

abstract interface class MigrationRepository {
  Future<bool> migrate({
    required UuidValue id,
    required String name,
    required String sql,
  });

  Future<bool> checkMigrationExists(UuidValue id);

  Future<bool> checkMigrationTableExists();
}
