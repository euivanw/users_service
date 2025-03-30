import 'package:uuid/uuid_value.dart';

import '../../../../../usecase/users/create_user/create_user_output_dto.dart';
import '../../shared/links_response_dto.dart';

final class CreateUserResponseDto {
  final UuidValue _id;
  final String _firstName;
  final String _lastName;
  final String _email;
  final DateTime _createdAt;
  final List<LinksResponseDto>? _links;

  const CreateUserResponseDto({
    required UuidValue id,
    required String firstName,
    required String lastName,
    required String email,
    required DateTime createdAt,
    List<LinksResponseDto>? links,
  }) : _id = id,
       _firstName = firstName,
       _lastName = lastName,
       _email = email,
       _createdAt = createdAt,
       _links = links;

  factory CreateUserResponseDto.fromOutputDto(
    CreateUserOutputDto output,
    List<LinksResponseDto> links,
  ) {
    return CreateUserResponseDto(
      id: output.id,
      firstName: output.firstName,
      lastName: output.lastName,
      email: output.email,
      createdAt: output.createdAt,
      links: links,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id.uuid,
      'firstName': _firstName,
      'lastName': _lastName,
      'email': _email,
      'createdAt': _createdAt.toIso8601String(),
      'links': _links?.map((link) => link.toMap()).toList(),
    };
  }
}
