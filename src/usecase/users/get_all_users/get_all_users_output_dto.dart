import 'package:uuid/uuid.dart';

final class GetAllUsersOutputDto {
  final List<GetAllUsersOutputUserDto> _users;

  const GetAllUsersOutputDto({required List<GetAllUsersOutputUserDto> users})
    : _users = users;

  List<GetAllUsersOutputUserDto> get users => _users;
}

final class GetAllUsersOutputUserDto {
  final UuidValue _id;
  final String _firstName;
  final String _lastName;
  final String _email;
  final DateTime _createdAt;
  final DateTime? _updatedAt;

  const GetAllUsersOutputUserDto({
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

  UuidValue get id => _id;

  String get firstName => _firstName;

  String get lastName => _lastName;

  String get email => _email;

  DateTime get createdAt => _createdAt;

  DateTime? get updatedAt => _updatedAt;
}
