import 'dart:convert';

import 'package:dart_either/dart_either.dart';

import '../../../../../usecase/users/create_user/create_user_input_dto.dart';
import '../../shared/validation_exception.dart';

final class CreateUserRequestDto {
  final String? _firstName;
  final String? _lastName;
  final String? _email;

  const CreateUserRequestDto({
    String? firstName,
    String? lastName,
    String? email,
  }) : _firstName = firstName,
       _lastName = lastName,
       _email = email;

  factory CreateUserRequestDto.fromMap(Map<String, dynamic> map) {
    return CreateUserRequestDto(
      firstName: map.containsKey('firstName') ? map['firstName'] : null,
      lastName: map.containsKey('lastName') ? map['lastName'] : null,
      email: map.containsKey('email') ? map['email'] : null,
    );
  }

  factory CreateUserRequestDto.fromJson(String source) {
    return CreateUserRequestDto.fromMap(json.decode(source));
  }

  CreateUserInputDto toInputDto() {
    return CreateUserInputDto(
      firstName: _firstName!,
      lastName: _lastName!,
      email: _email!,
    );
  }

  Either<ValidationException, void> validate() {
    if (_firstName == null) {
      return Left(
        ValidationException(businessMessage: 'First name is required.'),
      );
    }

    if (_firstName.isEmpty || _firstName.length < 3) {
      return Left(
        ValidationException(
          businessMessage: 'First name must be at least 3 characters.',
        ),
      );
    }

    if (_firstName.length > 50) {
      return Left(
        ValidationException(
          businessMessage: 'First name must be at most 50 characters.',
        ),
      );
    }

    if (_lastName == null) {
      return Left(
        ValidationException(businessMessage: 'Last name is required.'),
      );
    }

    if (_lastName.isEmpty || _lastName.length < 3) {
      return Left(
        ValidationException(
          businessMessage: 'Last name must be at least 3 characters.',
        ),
      );
    }

    if (_lastName.length > 50) {
      return Left(
        ValidationException(
          businessMessage: 'Last name must be at most 50 characters.',
        ),
      );
    }

    if (_email == null) {
      return Left(ValidationException(businessMessage: 'Email is required.'));
    }

    if (_email.isEmpty || _email.length < 5) {
      return Left(
        ValidationException(
          businessMessage: 'Email must be at least 5 characters.',
        ),
      );
    }

    if (_email.length > 100) {
      return Left(
        ValidationException(
          businessMessage: 'Email must be at most 100 characters.',
        ),
      );
    }

    return Right(null);
  }
}
