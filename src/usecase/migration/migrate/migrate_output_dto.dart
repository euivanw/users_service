import 'migrate_type.dart';

final class MigrateOutputDto {
  final MigrateType _type;

  const MigrateOutputDto({required MigrateType type}) : _type = type;

  MigrateType get type => _type;
}
