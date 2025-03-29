import 'package:uuid/uuid.dart';

class MigrationEntity {
  final UuidValue _id;
  final String _name;
  final String _sql;

  const MigrationEntity({
    required UuidValue id,
    required String name,
    required String sql,
  }) : _id = id,
       _name = name,
       _sql = sql;

  UuidValue get id => _id;

  String get name => _name;

  String get sql => _sql;

  @override
  String toString() {
    return '''
      MigrationEntity{
        id: $_id,
        name: $_name,
        sql: $_sql
      }
    ''';
  }
}
