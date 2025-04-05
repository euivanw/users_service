import 'package:uuid/uuid_value.dart';

final class UpdateUserInputDto {
  final UuidValue _id;
  final String _firstName;
  final String _lastName;
  final String _email;

  const UpdateUserInputDto({
    required UuidValue id,
    required String firstName,
    required String lastName,
    required String email,
  }) : _id = id,
       _firstName = firstName,
       _lastName = lastName,
       _email = email;

  UuidValue get id => _id;

  String get firstName => _firstName;

  String get lastName => _lastName;

  String get email => _email;
}
