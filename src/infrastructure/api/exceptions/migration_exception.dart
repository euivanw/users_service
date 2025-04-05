import '../../../shared/core_exception.dart';

class MigrationException extends CoreException {
  const MigrationException({
    required super.businessMessage,
    super.technicalMessage,
    super.stackTrace,
  });
}
