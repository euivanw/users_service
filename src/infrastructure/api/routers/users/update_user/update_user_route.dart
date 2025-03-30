import 'package:dart_either/dart_either.dart';
import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/validation.dart';

import '../../../../../shared/string_extension.dart';
import '../../../../../usecase/users/update_user/update_user_usecase.dart';
import '../../../../database/users/user_not_found_exception.dart';
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

    final body = await request.readAsString();
    final id = UuidValue.fromString(userId);
    final requestBody = _validateParseBody(body, id);

    if (requestBody.isLeft) {
      return (requestBody as Left).value;
    }

    final userRequestBody = (requestBody as Right).value;
    final repository = UsersRepositoryImpl(connection: _dbconn);
    final usecase = UpdateUserUsecase(repository: repository);
    final created = await usecase.execute(userRequestBody.toInputDto());

    return created.fold(
      ifLeft: (exception) {
        if (exception is UserNotFoundException) {
          return JsonResponse.notFound(exception.businessMessage);
        }

        return JsonResponse.internalServerError(exception.businessMessage);
      },
      ifRight: (output) {
        return JsonResponse.created(
          UpdateUserResponseDto.fromOutputDto(output).toMap(),
        );
      },
    );
  }

  Either<Response, UpdateUserRequestDto> _validateParseBody(
    String body,
    UuidValue userId,
  ) {
    UpdateUserRequestDto requestBody;

    try {
      requestBody = UpdateUserRequestDto.fromJson(body, userId);
    } catch (exception) {
      final message = exception.toString().formatText;
      _logger.warning('Invalid JSON format: $message');

      return Left(JsonResponse.badRequest('Invalid JSON format.'));
    }

    final validationBody = requestBody.validate();

    if (validationBody.isLeft) {
      final message = (validationBody as Left).value.businessMessage;
      _logger.warning('Validation failed: $message');

      return Left(JsonResponse.badRequest(message));
    }

    return Right(requestBody);
  }
}
