import 'package:dart_either/dart_either.dart';
import 'package:logging/logging.dart';

import '../../../domain/users/users_exception.dart';
import '../../../domain/users/users_repository.dart';
import '../../shared/usecase.dart';
import 'get_all_users_input_dto.dart';
import 'get_all_users_output_dto.dart';

final class GetAllUsersUsecase
    implements
        Usecase<GetAllUsersInputDto, GetAllUsersOutputDto, UsersException> {
  final Logger _logger;
  final UsersRepository _repository;

  GetAllUsersUsecase({required UsersRepository repository})
    : _repository = repository,
      _logger = Logger('GetAllUsersUsecase');

  @override
  Future<Either<UsersException, GetAllUsersOutputDto>> execute(
    GetAllUsersInputDto input,
  ) async {
    try {
      final users = await _repository.getAllUsers();

      _logger.info('Fetched ${users.length} users: [$users]');

      return Right(
        GetAllUsersOutputDto(
          users:
              users
                  .map(
                    (user) => GetAllUsersOutputUserDto(
                      id: user.id,
                      firstName: user.firstName,
                      lastName: user.lastName,
                      email: user.email,
                      createdAt: user.createdAt,
                      updatedAt: user.updatedAt,
                    ),
                  )
                  .toList(),
        ),
      );
    } on UsersException catch (exception, stackTrace) {
      _logger.severe(
        'Failed to retrieve users: ${exception.businessMessage}',
        exception,
        stackTrace,
      );

      return Left(exception);
    } catch (exception, stackTrace) {
      _logger.severe(
        'An unexpected error occurred while retrieving users: $exception',
        exception,
        stackTrace,
      );

      return Left(
        UsersException(
          businessMessage:
              'An unexpected error occurred while retrieving the users.',
          technicalMessage: exception.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
