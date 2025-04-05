import '../../../../shared/core_exception.dart';

class ValidationException extends CoreException {
  const ValidationException({
    required super.businessMessage,
    super.technicalMessage,
    super.stackTrace,
  });
}
