import 'package:uuid/uuid.dart';

import 'users_entity.dart';

abstract interface class UsersRepository {
  Future<UsersEntity> createUser({
    required String firstName,
    required String lastName,
    required String email,
  });

  Future<UsersEntity> updateUser({
    required UuidValue id,
    required String firstName,
    required String lastName,
    required String email,
  });

  Future<UsersEntity> deleteUser({required UuidValue id});

  Future<UsersEntity> getUserById({required UuidValue id});

  Future<List<UsersEntity>> getAllUsers();
}
