import 'package:dart_either/dart_either.dart';
import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/validation.dart';

import '../../../../../shared/string_extension.dart';
import '../../../../../usecase/users/update_user/update_user_usecase.dart';
import '../../../../database/users/users_repository_impl.dart';
import '../../server_instance.dart';
import '../../shared/core_router.dart';
import '../../shared/json_response.dart';
import 'update_user_request_dto.dart';
import 'update_user_response_dto.dart';

final class UpdateUserRoute implements CoreRouter {
  final Logger _logger;
  final ServerInstance _instance;
  final Connection _dbconn;

  UpdateUserRoute({
    required ServerInstance instance,
    required Connection dbconn,
  }) : _instance = instance,
       _dbconn = dbconn,
       _logger = Logger('UpdateUserRoute');

  @override
  Future<void> configure() async {
    final route = '/${_instance.apiVersion}/users/<userId>';
    _instance.app.put(route, _createUser);

    _logger.info('Registering route PUT $route');
  }

  Future<Response> _createUser(Request request, String userId) async {
    if (!UuidValidation.isValidUUID(fromString: userId)) {
      return JsonResponse.badRequest('User ID [$userId] must be a valid UUID.');
    }

    _logger.info('Updating user with ID: $userId');

    final requestBody = await request.readAsString();
    UpdateUserRequestDto requestBodyObject;

    try {
      final id = UuidValue.fromString(userId);
      requestBodyObject = UpdateUserRequestDto.fromJson(requestBody, id);
    } catch (exception) {
      _logger.severe(
        'Invalid JSON format: ${exception.toString().formatText}',
        exception,
      );
      return JsonResponse.badRequest('Invalid JSON format.');
    }

    final validationBody = requestBodyObject.validate();

    if (validationBody.isLeft) {
      _logger.severe(
        'Validation failed: ${validationBody.toString()}',
        validationBody,
      );

      return JsonResponse.badRequest(
        (validationBody as Left).value.businessMessage,
      );
    }

    final repository = UsersRepositoryImpl(connection: _dbconn);
    final usecase = UpdateUserUsecase(repository: repository);
    final created = await usecase.execute(requestBodyObject.toInputDto());

    return created.fold(
      ifLeft: (exception) {
        _logger.severe(
          'Error updating user: ${requestBodyObject.toInputDto()} (${exception.technicalMessage}).',
          exception,
        );
        return JsonResponse.internalServerError(exception.businessMessage);
      },
      ifRight: (output) {
        _logger.info('User updated successfully: ${output.toString()}');
        return JsonResponse.created(
          UpdateUserResponseDto.fromOutputDto(output).toMap(),
        );
      },
    );
  }
}
