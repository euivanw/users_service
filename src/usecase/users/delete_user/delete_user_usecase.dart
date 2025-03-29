import 'package:dart_either/src/dart_either.dart';

import '../../../domain/users/users_exception.dart';
import '../../../domain/users/users_repository.dart';
import '../../shared/usecase.dart';
import 'delete_user_input_dto.dart';
import 'delete_user_output_dto.dart';

final class DeleteUserUsecase
    implements
        Usecase<DeleteUserInputDto, DeleteUserOutputDto, UsersException> {
  final UsersRepository _usersRepository;

  const DeleteUserUsecase({required UsersRepository usersRepository})
    : _usersRepository = usersRepository;

  @override
  Future<Either<UsersException, DeleteUserOutputDto>> execute(
    DeleteUserInputDto input,
  ) async {
    try {
      final user = await _usersRepository.deleteUser(id: input.id);

      return Right(
        DeleteUserOutputDto(
          id: user.id,
          firstName: user.firstName,
          lastName: user.lastName,
          email: user.email,
          createdAt: user.createdAt,
          updatedAt: user.updatedAt,
        ),
      );
    } on UsersException catch (e) {
      return Left(e);
    } catch (exception, stackTrace) {
      return Left(
        UsersException(
          businessMessage:
              'An unexpected error occurred while deleting the user.',
          technicalMessage: exception.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
