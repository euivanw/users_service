import 'package:dart_either/src/dart_either.dart';
import 'package:logging/logging.dart';

import '../../../domain/users/users_exception.dart';
import '../../../domain/users/users_repository.dart';
import '../../shared/usecase.dart';
import 'create_user_input_dto.dart';
import 'create_user_output_dto.dart';

final class CreateUserUsecase
    implements
        Usecase<CreateUserInputDto, CreateUserOutputDto, UsersException> {
  final Logger _logger;
  final UsersRepository _repository;

  CreateUserUsecase({required UsersRepository repository})
    : _repository = repository,
      _logger = Logger('CreateUserUsecase');

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

      _logger.info('User created successfully: ${user.id}');

      return Right(
        CreateUserOutputDto(
          id: user.id,
          firstName: user.firstName,
          lastName: user.lastName,
          email: user.email,
          createdAt: user.createdAt,
        ),
      );
    } on UsersException catch (exception, stackTrace) {
      _logger.severe(
        'Failed to create user: ${exception.businessMessage}',
        exception,
        stackTrace,
      );

      return Left(exception);
    } catch (exception, stackTrace) {
      _logger.severe(
        'Failed to create user: ${exception.toString()}',
        exception,
        stackTrace,
      );

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
