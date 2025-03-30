

final class CreateUserInputDto {
  final String _firstName;
  final String _lastName;
  final String _email;

  const CreateUserInputDto({
    required String firstName,
    required String lastName,
    required String email,
  }) : _firstName = firstName,
       _lastName = lastName,
       _email = email;

  String get firstName => _firstName;

  String get lastName => _lastName;

  String get email => _email;
}
