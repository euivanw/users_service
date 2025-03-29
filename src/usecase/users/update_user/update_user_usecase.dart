import 'package:dart_either/dart_either.dart';

import '../../../domain/users/users_exception.dart';
import '../../../domain/users/users_repository.dart';
import '../../shared/usecase.dart';
import 'update_user_input_dto.dart';
import 'update_user_output_dto.dart';

final class UpdateUserUsecase
    implements
        Usecase<UpdateUserInputDto, UpdateUserOutputDto, UsersException> {
  final UsersRepository _repository;

  const UpdateUserUsecase({required UsersRepository repository})
    : _repository = repository;

  @override
  Future<Either<UsersException, UpdateUserOutputDto>> execute(
    UpdateUserInputDto input,
  ) async {
    try {
      final user = await _repository.updateUser(
        id: input.id,
        firstName: input.firstName,
        lastName: input.lastName,
        email: input.email,
      );

      return Right(
        UpdateUserOutputDto(
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
              'An unexpected error occurred while updating the user.',
          technicalMessage: exception.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
