import '../../../shared/core_exception.dart';

class DatabaseException extends CoreException {
  const DatabaseException({
    required super.businessMessage,
    super.technicalMessage,
    super.stackTrace,
  });
}
