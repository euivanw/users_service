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
    MigrationEntity(
      id: UuidValue.fromString('a254ef87-f7a4-467d-bfc6-183622efe748'),
      name: 'Create users table',
      sql: '''
        CREATE TABLE users (
          id UUID PRIMARY KEY,
          first_name VARCHAR(50) NOT NULL,
          last_name VARCHAR(50) NOT NULL,
          email VARCHAR(150) NOT NULL,
          created_at TIMESTAMP NOT NULL DEFAULT NOW(),
          updated_at TIMESTAMP,
          CONSTRAINT idx_users_email UNIQUE (email)
        );
      ''',
    ),
    MigrationEntity(
      id: UuidValue.fromString('ebf1c2a0-3d4e-4b8c-9f5d-7a2e6f1a5b8c'),
      name: 'Create user first name index',
      sql: '''
        CREATE INDEX idx_users_first_name ON users (first_name);
      ''',
    ),
    MigrationEntity(
      id: UuidValue.fromString('fb2c3d4e-5a6b-7c8d-9e0f-1a2b3c4d5e6f'),
      name: 'Create user last name index',
      sql: '''
        CREATE INDEX idx_users_last_name ON users (last_name);
      ''',
    ),
  ];
}
