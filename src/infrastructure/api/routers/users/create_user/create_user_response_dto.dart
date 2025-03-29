import 'package:uuid/uuid_value.dart';

import '../../../../../usecase/users/create_user/create_user_output_dto.dart';

final class CreateUserResponseDto {
  final UuidValue _id;
  final String _firstName;
  final String _lastName;
  final String _email;
  final DateTime _createdAt;

  const CreateUserResponseDto({
    required UuidValue id,
    required String firstName,
    required String lastName,
    required String email,
    required DateTime createdAt,
  }) : _id = id,
       _firstName = firstName,
       _lastName = lastName,
       _email = email,
       _createdAt = createdAt;

  factory CreateUserResponseDto.fromOutputDto(CreateUserOutputDto output) {
    return CreateUserResponseDto(
      id: output.id,
      firstName: output.firstName,
      lastName: output.lastName,
      email: output.email,
      createdAt: output.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id.uuid,
      'firstName': _firstName,
      'lastName': _lastName,
      'email': _email,
      'createdAt': _createdAt.toIso8601String(),
    };
  }
}
