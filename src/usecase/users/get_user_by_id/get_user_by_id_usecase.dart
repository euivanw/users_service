import 'package:dart_either/dart_either.dart';
import 'package:logging/logging.dart';

import '../../../domain/users/users_exception.dart';
import '../../../domain/users/users_repository.dart';
import '../../../infrastructure/database/users/user_not_found_exception.dart';
import '../../shared/usecase.dart';
import 'get_user_by_id_input_dto.dart';
import 'get_user_by_id_output_dto.dart';

final class GetUserByIdUsecase
    implements
        Usecase<GetUserByIdInputDto, GetUserByIdOutputDto, UsersException> {
  final Logger _logger;
  final UsersRepository _repository;

  GetUserByIdUsecase({required UsersRepository repository})
    : _repository = repository,
      _logger = Logger('GetUserByIdUsecase');

  @override
  Future<Either<UsersException, GetUserByIdOutputDto>> execute(
    GetUserByIdInputDto input,
  ) async {
    try {
      final user = await _repository.getUserById(id: input.id);

      _logger.info('User retrieved successfully: ${user.id}');

      return Right(
        GetUserByIdOutputDto(
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
        'Failed to retrieve user with ID: ${input.id}',
        exception,
        stackTrace,
      );

      return Left(exception);
    } catch (exception, stackTrace) {
      _logger.severe(
        'An unexpected error occurred while retrieving user with ID: ${input.id}',
        exception,
        stackTrace,
      );

      return Left(
        UsersException(
          businessMessage:
              'An unexpected error occurred while retrieving the user.',
          technicalMessage: exception.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
