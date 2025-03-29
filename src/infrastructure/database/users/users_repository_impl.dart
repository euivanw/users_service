import 'package:postgres/postgres.dart';
import 'package:uuid/uuid.dart';

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
  }) async {
    try {
      final userId = Uuid().v4();

      final result = await _connection.execute(
        Sql.named('''
          INSERT INTO users (id, first_name, last_name, email)
          VALUES (@id, @firstName, @lastName, @email)
          RETURNING id, first_name, last_name, email, created_at
        '''),
        parameters: {
          'id': userId,
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
        },
      );

      return UsersEntity(
        id: UuidValue.fromString(result[0][0] as String),
        firstName: result[0][1] as String,
        lastName: result[0][2] as String,
        email: result[0][3] as String,
        createdAt: result[0][4] as DateTime,
        updatedAt: null,
      );
    } on UsersException {
      rethrow;
    } catch (exception, stackTrace) {
      throw UsersException(
        businessMessage:
            'Failed to create user with name [$firstName $lastName] and e-mail [$email]. Please try again.',
        technicalMessage: 'Unknown error: $exception',
        stackTrace: stackTrace,
      );
    }
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
  }) async {
    try {
      final result = await _connection.execute(
        Sql.named('''
          UPDATE  users
          SET     first_name = @firstName,
                  last_name = @lastName,
                  email = @email,
                  updated_at = NOW()
          WHERE   id = @id
          RETURNING id, first_name, last_name, email, created_at, updated_at
        '''),
        parameters: {
          'id': id.uuid,
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
        },
      );

      return UsersEntity(
        id: UuidValue.fromString(result[0][0] as String),
        firstName: result[0][1] as String,
        lastName: result[0][2] as String,
        email: result[0][3] as String,
        createdAt: result[0][4] as DateTime,
        updatedAt: result[0][5] as DateTime,
      );
    } on UsersException {
      rethrow;
    } catch (exception, stackTrace) {
      throw UsersException(
        businessMessage:
            'Failed to update user with name [$firstName $lastName] and e-mail [$email]. Please try again.',
        technicalMessage: 'Unknown error: $exception',
        stackTrace: stackTrace,
      );
    }
  }
}
