import 'package:uuid/uuid.dart';

import '../../../../../usecase/users/get_all_users/get_all_users_output_dto.dart';
import '../../shared/links_response_dto.dart';

final class GetAllUsersResponseDto {
  final List<GetAllUsersResponseUserDto> _users;

  const GetAllUsersResponseDto({
    required List<GetAllUsersResponseUserDto> users,
  }) : _users = users;

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
  final List<LinksResponseDto>? _links;

  const GetAllUsersResponseUserDto({
    required UuidValue id,
    required String firstName,
    required String lastName,
    required String email,
    required DateTime createdAt,
    DateTime? updatedAt,
    List<LinksResponseDto>? links,
  }) : _id = id,
       _firstName = firstName,
       _lastName = lastName,
       _email = email,
       _createdAt = createdAt,
       _updatedAt = updatedAt,
       _links = links;

  factory GetAllUsersResponseUserDto.fromOutputDto(
    GetAllUsersOutputUserDto output,
    List<LinksResponseDto> links,
  ) {
    return GetAllUsersResponseUserDto(
      id: output.id,
      firstName: output.firstName,
      lastName: output.lastName,
      email: output.email,
      createdAt: output.createdAt,
      updatedAt: output.updatedAt,
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
      'updatedAt': _updatedAt?.toIso8601String(),
      'links': _links?.map((link) => link.toMap()).toList(),
    };
  }
}
