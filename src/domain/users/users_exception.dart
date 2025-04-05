import '../../shared/core_exception.dart';

class UsersException extends CoreException {
  const UsersException({
    required super.businessMessage,
    super.technicalMessage,
    super.stackTrace,
  });
}
