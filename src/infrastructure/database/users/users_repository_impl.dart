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
      final user = await _connection.execute(
        Sql.named('''
          INSERT INTO users (
            id,
            first_name,
            last_name,
            email
          ) VALUES (
            @id,
            @firstName,
            @lastName,
            @email
          )
          RETURNING 
            id,
            first_name,
            last_name,
            email,
            created_at
        '''),
        parameters: {
          'id': Uuid().v4(),
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
        },
      );

      return UsersEntity(
        id: UuidValue.fromString(user[0][0] as String),
        firstName: user[0][1] as String,
        lastName: user[0][2] as String,
        email: user[0][3] as String,
        createdAt: user[0][4] as DateTime,
      );
    } on UsersException {
      rethrow;
    } catch (exception, stackTrace) {
      throw UsersException(
        businessMessage: 'Failed to create user.',
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
  Future<List<UsersEntity>> getAllUsers() async {
    try {
      final userList = await _connection.execute(
        Sql.named('''
          SELECT    id,
                    first_name,
                    last_name,
                    email,
                    created_at,
                    updated_at
          FROM      users
          ORDER BY  first_name, last_name, email
        '''),
      );

      return userList.map((user) {
        return UsersEntity(
          id: UuidValue.fromString(user[0] as String),
          firstName: user[1] as String,
          lastName: user[2] as String,
          email: user[3] as String,
          createdAt: user[4] as DateTime,
          updatedAt: user[5] as DateTime?,
        );
      }).toList();
    } on UsersException {
      rethrow;
    } catch (exception, stackTrace) {
      throw UsersException(
        businessMessage: 'Failed to retrieve all users.',
        technicalMessage: 'Unknown error: $exception',
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<UsersEntity> getUserById({required UuidValue id}) async {
    try {
      final user = await _connection.execute(
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

      if (user.isEmpty) {
        throw UserNotFoundException(
          businessMessage: 'User with ID [${id.uuid}] was not found.',
        );
      }

      return UsersEntity(
        id: UuidValue.fromString(user[0][0] as String),
        firstName: user[0][1] as String,
        lastName: user[0][2] as String,
        email: user[0][3] as String,
        createdAt: user[0][4] as DateTime,
        updatedAt: user[0][5] as DateTime?,
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
        businessMessage: 'Failed to retrieve user with ID [${id.uuid}]',
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
      final user = await _connection.execute(
        Sql.named('''
          UPDATE      users
          SET         first_name = @firstName,
                      last_name = @lastName,
                      email = @email,
                      updated_at = NOW()
          WHERE       id = @id
          RETURNING   id,
                      first_name,
                      last_name,
                      email,
                      created_at,
                      updated_at
        '''),
        parameters: {
          'id': id.uuid,
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
        },
      );

      return UsersEntity(
        id: UuidValue.fromString(user[0][0] as String),
        firstName: user[0][1] as String,
        lastName: user[0][2] as String,
        email: user[0][3] as String,
        createdAt: user[0][4] as DateTime,
        updatedAt: user[0][5] as DateTime,
      );
    } on UsersException {
      rethrow;
    } catch (exception, stackTrace) {
      throw UsersException(
        businessMessage: 'Failed to update user with ID [${id.uuid}].',
        technicalMessage: 'Unknown error: $exception',
        stackTrace: stackTrace,
      );
    }
  }
}
