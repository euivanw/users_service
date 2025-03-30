import 'package:dart_either/dart_either.dart';
import 'package:logging/logging.dart';

import '../../../domain/users/users_exception.dart';
import '../../../domain/users/users_repository.dart';
import '../../../infrastructure/database/users/user_not_found_exception.dart';
import '../../shared/usecase.dart';
import 'update_user_input_dto.dart';
import 'update_user_output_dto.dart';

final class UpdateUserUsecase
    implements
        Usecase<UpdateUserInputDto, UpdateUserOutputDto, UsersException> {
  final Logger _logger;
  final UsersRepository _repository;

  UpdateUserUsecase({required UsersRepository repository})
    : _repository = repository,
      _logger = Logger('UpdateUserUsecase');

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
    } on UserNotFoundException catch (exception) {
      _logger.warning('User not found with ID: ${input.id}');

      return Left(exception);
    } on UsersException catch (exception, stackTrace) {
      _logger.severe(
        'Failed to update user with ID: ${input.id}',
        exception,
        stackTrace,
      );

      return Left(exception);
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
