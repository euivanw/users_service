import 'package:dart_either/src/dart_either.dart';

import '../../../domain/users/users_exception.dart';
import '../../../domain/users/users_repository.dart';
import '../../shared/usecase.dart';
import 'create_user_input_dto.dart';
import 'create_user_output_dto.dart';

final class CreateUserUsecase
    implements
        Usecase<CreateUserInputDto, CreateUserOutputDto, UsersException> {
  final UsersRepository _repository;

  const CreateUserUsecase({required UsersRepository repository})
    : _repository = repository;

  @override
  Future<Either<UsersException, CreateUserOutputDto>> execute(
    CreateUserInputDto input,
  ) async {
    try {
      final user = await _repository.createUser(
        firstName: input.firstName,
        lastName: input.lastName,
        email: input.email,
      );

      return Right(
        CreateUserOutputDto(
          id: user.id,
          firstName: user.firstName,
          lastName: user.lastName,
          email: user.email,
          createdAt: user.createdAt,
        ),
      );
    } on UsersException catch (e) {
      return Left(e);
    } catch (exception, stackTrace) {
      return Left(
        UsersException(
          businessMessage:
              'An unexpected error occurred while creating the user.',
          technicalMessage: exception.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
