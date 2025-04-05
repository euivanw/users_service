import 'dart:convert';

import 'package:dart_either/dart_either.dart';
import 'package:uuid/uuid_value.dart';

import '../../../../../usecase/users/update_user/update_user_input_dto.dart';
import '../../shared/validation_exception.dart';

final class UpdateUserRequestDto {
  final UuidValue? _id;
  final String? _firstName;
  final String? _lastName;
  final String? _email;

  const UpdateUserRequestDto({
    UuidValue? id,
    String? firstName,
    String? lastName,
    String? email,
  }) : _id = id,
       _firstName = firstName,
       _lastName = lastName,
       _email = email;

  factory UpdateUserRequestDto.fromMap(
    Map<String, dynamic> map,
    UuidValue userId,
  ) {
    return UpdateUserRequestDto(
      id: userId,
      firstName: map.containsKey('firstName') ? map['firstName'] : null,
      lastName: map.containsKey('lastName') ? map['lastName'] : null,
      email: map.containsKey('email') ? map['email'] : null,
    );
  }

  factory UpdateUserRequestDto.fromJson(String source, UuidValue userId) {
    return UpdateUserRequestDto.fromMap(json.decode(source), userId);
  }

  UpdateUserInputDto toInputDto() {
    return UpdateUserInputDto(
      id: _id!,
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
