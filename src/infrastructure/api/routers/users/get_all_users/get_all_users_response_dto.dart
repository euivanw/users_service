import 'package:uuid/uuid.dart';

import '../../../../../usecase/users/get_all_users/get_all_users_output_dto.dart';

final class GetAllUsersResponseDto {
  final List<GetAllUsersResponseUserDto> _users;

  const GetAllUsersResponseDto({
    required List<GetAllUsersResponseUserDto> users,
  }) : _users = users;

  factory GetAllUsersResponseDto.fromOutputDto(GetAllUsersOutputDto output) {
    return GetAllUsersResponseDto(
      users:
          output.users
              .map((user) => GetAllUsersResponseUserDto.fromOutputDto(user))
              .toList(),
    );
  }

  List<Map<String, dynamic>> toMap() {
    return _users.map((user) => user.toMap()).toList();
  }

  int get length => _users.length;
}

final class GetAllUsersResponseUserDto {
  final UuidValue _id;
  final String _firstName;
  final String _lastName;
  final String _email;
  final DateTime _createdAt;
  final DateTime? _updatedAt;

  const GetAllUsersResponseUserDto({
    required UuidValue id,
    required String firstName,
    required String lastName,
    required String email,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : _id = id,
       _firstName = firstName,
       _lastName = lastName,
       _email = email,
       _createdAt = createdAt,
       _updatedAt = updatedAt;

  factory GetAllUsersResponseUserDto.fromOutputDto(
    GetAllUsersOutputUserDto output,
  ) {
    return GetAllUsersResponseUserDto(
      id: output.id,
      firstName: output.firstName,
      lastName: output.lastName,
      email: output.email,
      createdAt: output.createdAt,
      updatedAt: output.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id.uuid,
      'firstName': _firstName,
      'lastName': _lastName,
      'email': _email,
      'createdAt': _createdAt.toIso8601String(),
      'updatedAt': _updatedAt?.toIso8601String(),
    };
  }
}
