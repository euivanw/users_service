import 'dart:convert';

import 'package:uuid/uuid.dart';

final class UpdateUserOutputDto {
  final UuidValue _id;
  final String _firstName;
  final String _lastName;
  final String _email;
  final DateTime _createdAt;
  final DateTime? _updatedAt;

  const UpdateUserOutputDto({
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

  @override
  String toString() {
    return json.encode({
      'id': _id.uuid,
      'firstName': _firstName,
      'lastName': _lastName,
      'email': _email,
      'createdAt': _createdAt.toIso8601String(),
      'updatedAt': _updatedAt?.toIso8601String(),
    });
  }
}
