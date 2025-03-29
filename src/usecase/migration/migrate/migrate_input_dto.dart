import 'package:uuid/uuid.dart';

class MigrateInputDto {
  final UuidValue _id;
  final String _name;
  final String _sql;

  const MigrateInputDto({
    required UuidValue id,
    required String name,
    required String sql,
  }) : _id = id,
       _name = name,
       _sql = sql;

  UuidValue get id => _id;

  String get name => _name;

  String get sql => _sql;
}
