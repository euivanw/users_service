import 'package:uuid/uuid.dart';

final class GetUserByIdOutputDto {
  final UuidValue _id;
  final String _firstName;
  final String _lastName;
  final String _email;
  final DateTime _createdAt;
  final DateTime? _updatedAt;

  const GetUserByIdOutputDto({
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
    return '''
      GetUserByIdOutputDto{
        id: $_id,
        firstName: $_firstName,
        lastName: $_lastName,
        email: $_email,
        createdAt: $_createdAt,
        updatedAt: $_updatedAt
      }
    ''';
  }
}
