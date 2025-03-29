import 'package:dart_either/dart_either.dart';

import '../../../domain/users/users_exception.dart';
import '../../../domain/users/users_repository.dart';
import '../../shared/usecase.dart';
import 'get_user_by_id_input_dto.dart';
import 'get_user_by_id_output_dto.dart';

final class GetUserByIdUsecase
    implements
        Usecase<GetUserByIdInputDto, GetUserByIdOutputDto, UsersException> {
  final UsersRepository _usersRepository;

  const GetUserByIdUsecase({required UsersRepository usersRepository})
    : _usersRepository = usersRepository;

  @override
  Future<Either<UsersException, GetUserByIdOutputDto>> execute(
    GetUserByIdInputDto input,
  ) async {
    try {
      final user = await _usersRepository.getUserById(id: input.id);

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
    } on UsersException catch (e) {
      return Left(e);
    } catch (exception, stackTrace) {
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
