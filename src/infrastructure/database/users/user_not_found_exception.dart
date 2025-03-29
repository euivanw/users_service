import '../../../domain/users/users_exception.dart';
import '../../../shared/core_exception.dart';

final class UserNotFoundException extends UsersException {
  const UserNotFoundException({
    required super.businessMessage,
    super.technicalMessage,
    super.stackTrace,
  });
}
