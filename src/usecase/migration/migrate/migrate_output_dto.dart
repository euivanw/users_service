import 'migrate_type.dart';

class MigrateOutputDto {
  final MigrateType _type;

  const MigrateOutputDto({required MigrateType type}) : _type = type;

  MigrateType get type => _type;
}
