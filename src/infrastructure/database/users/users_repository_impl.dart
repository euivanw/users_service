import 'package:postgres/postgres.dart';
import 'package:uuid/uuid_value.dart';

import '../../../domain/users/users_entity.dart';
import '../../../domain/users/users_exception.dart';
import '../../../domain/users/users_repository.dart';
import 'user_not_found_exception.dart';

final class UsersRepositoryImpl implements UsersRepository {
  final Connection _connection;

  const UsersRepositoryImpl({required Connection connection})
    : _connection = connection;

  @override
  Future<UsersEntity> createUser({
    required String firstName,
    required String lastName,
    required String email,
  }) {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  Future<UsersEntity> deleteUser({required UuidValue id}) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<List<UsersEntity>> getAllUsers() {
    // TODO: implement getAllUsers
    throw UnimplementedError();
  }

  @override
  Future<UsersEntity> getUserById({required UuidValue id}) async {
    try {
      final result = await _connection.execute(
        Sql.named('''
          SELECT  id,
                  first_name,
                  last_name,
                  email,
                  created_at,
                  updated_at
          FROM    users
          WHERE   id = @id
        '''),
        parameters: {'id': id.uuid},
      );

      if (result.isEmpty) {
        throw UserNotFoundException(
          businessMessage: 'User with ID [${id.uuid}] was not found.',
        );
      }

      return UsersEntity(
        id: UuidValue.fromString(result[0][0] as String),
        firstName: result[0][1] as String,
        lastName: result[0][2] as String,
        email: result[0][3] as String,
        createdAt: result[0][4] as DateTime,
        updatedAt: result[0][5] as DateTime?,
      );
    } on UsersException {
      rethrow;
    } on AssertionError catch (exception, stackTrace) {
      throw UsersException(
        businessMessage:
            exception.message?.toString() ??
            'Error retrieving user with ID [${id.uuid}].',
        technicalMessage: 'Unknown error: $exception',
        stackTrace: stackTrace,
      );
    } catch (exception, stackTrace) {
      throw UsersException(
        businessMessage:
            'Failed to retrieve user with ID [${id.uuid}]. Please try again.',
        technicalMessage: 'Unknown error: $exception',
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<UsersEntity> updateUser({
    required UuidValue id,
    required String firstName,
    required String lastName,
    required String email,
  }) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
