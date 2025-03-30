import 'package:uuid/uuid.dart';

import '../../../../../usecase/users/delete_user/delete_user_output_dto.dart';

final class DeleteUserResponseDto {
  final UuidValue _id;
  final String _firstName;
  final String _lastName;
  final String _email;
  final DateTime _createdAt;
  final DateTime? _updatedAt;

  const DeleteUserResponseDto({
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

  factory DeleteUserResponseDto.fromOutputDto(DeleteUserOutputDto output) {
    return DeleteUserResponseDto(
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
