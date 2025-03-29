import 'package:dart_either/dart_either.dart';

import '../../../domain/users/users_exception.dart';
import '../../../domain/users/users_repository.dart';
import '../../shared/usecase.dart';
import 'get_all_users_input_dto.dart';
import 'get_all_users_output_dto.dart';

final class GetAllUsersUsecase
    implements
        Usecase<GetAllUsersInputDto, GetAllUsersOutputDto, UsersException> {
  final UsersRepository _usersRepository;

  const GetAllUsersUsecase({required UsersRepository usersRepository})
    : _usersRepository = usersRepository;

  @override
  Future<Either<UsersException, GetAllUsersOutputDto>> execute(
    GetAllUsersInputDto input,
  ) async {
    try {
      final users = await _usersRepository.getAllUsers();

      return Right(
        GetAllUsersOutputDto(
          users:
              users
                  .map(
                    (user) => UserDto(
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
    } on UsersException catch (e) {
      return Left(e);
    } catch (exception, stackTrace) {
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
