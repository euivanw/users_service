import 'package:uuid/uuid.dart';

import '../../../domain/migration/migration_entity.dart';

abstract class MigrationConfig {
  static final migrations = [
    MigrationEntity(
      id: UuidValue.fromString('153996a9-0467-49ac-a3c0-92286104929c'),
      name: 'Enable UUID support',
      sql: '''
        CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
      ''',
    ),
  ];
}
