import 'package:dart_either/dart_either.dart';
import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';

import '../../../../../shared/string_extension.dart';
import '../../../../../usecase/users/create_user/create_user_usecase.dart';
import '../../../../database/users/users_repository_impl.dart';
import '../../server_instance.dart';
import '../../shared/core_router.dart';
import '../../shared/json_response.dart';
import 'create_user_request_dto.dart';
import 'create_user_response_dto.dart';

final class CreateUserRoute implements CoreRouter {
  final Logger _logger;
  final ServerInstance _instance;
  final Connection _dbconn;

  CreateUserRoute({
    required ServerInstance instance,
    required Connection dbconn,
  }) : _instance = instance,
       _dbconn = dbconn,
       _logger = Logger('CreateUserRoute');

  @override
  Future<void> configure() async {
    final route = '/${_instance.apiVersion}/users';
    _instance.app.post(route, _createUser);

    _logger.info('Registering route POST $route');
  }

  Future<Response> _createUser(Request request) async {
    final requestBody = await request.readAsString();
    CreateUserRequestDto requestBodyObject;

    try {
      requestBodyObject = CreateUserRequestDto.fromJson(requestBody);
    } catch (exception) {
      _logger.severe(
        'Invalid JSON format: ${exception.toString().formatText}',
        exception,
      );
      return JsonResponse.badRequest('Invalid JSON format.');
    }

    _logger.info('Creating user with: $requestBodyObject');

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
    final usecase = CreateUserUsecase(repository: repository);
    final created = await usecase.execute(requestBodyObject.toInputDto());

    return created.fold(
      ifLeft: (exception) {
        _logger.severe(
          'Error creating user: ${requestBodyObject.toInputDto()} (${exception.technicalMessage}).',
          exception,
        );
        return JsonResponse.internalServerError(exception.businessMessage);
      },
      ifRight: (output) {
        _logger.info('User created successfully: ${output.toString()}');
        return JsonResponse.created(
          CreateUserResponseDto.fromOutputDto(output).toMap(),
        );
      },
    );
  }
}
