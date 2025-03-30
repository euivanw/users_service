import 'package:dart_either/dart_either.dart';
import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:uuid/uuid_value.dart';

import '../../../../../shared/string_extension.dart';
import '../../../../../usecase/users/create_user/create_user_usecase.dart';
import '../../../../database/users/users_repository_impl.dart';
import '../../server_instance.dart';
import '../../shared/core_router.dart';
import '../../shared/json_response.dart';
import '../../shared/link_method_enum.dart';
import '../../shared/link_relation_enum.dart';
import '../../shared/links_response_dto.dart';
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

  Either<Response, CreateUserRequestDto> _validateParseBody(String body) {
    CreateUserRequestDto requestBody;

    try {
      requestBody = CreateUserRequestDto.fromJson(body);
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

  Future<Response> _createUser(Request request) async {
    _logger.info('Creating user...');

    final body = await request.readAsString();
    final requestBody = _validateParseBody(body);

    if (requestBody.isLeft) {
      return (requestBody as Left).value;
    }

    final userRequestBody = (requestBody as Right).value;
    final repository = UsersRepositoryImpl(connection: _dbconn);
    final usecase = CreateUserUsecase(repository: repository);
    final created = await usecase.execute(userRequestBody.toInputDto());

    return created.fold(
      ifLeft: (exception) {
        return JsonResponse.internalServerError(exception.businessMessage);
      },
      ifRight: (output) {
        final links = _createLinks(output.id);
        final createdUser = CreateUserResponseDto.fromOutputDto(output, links);

        return JsonResponse.created(createdUser.toMap());
      },
    );
  }

  List<LinksResponseDto> _createLinks(UuidValue id) {
    return [
      LinksResponseDto(
        rel: LinkRelationEnum.self,
        href: '/${_instance.apiVersion}/users/${id.uuid}',
        method: LinkMethodEnum.get,
      ),
      LinksResponseDto(
        rel: LinkRelationEnum.update,
        href: '/${_instance.apiVersion}/users/${id.uuid}',
        method: LinkMethodEnum.put,
      ),
      LinksResponseDto(
        rel: LinkRelationEnum.delete,
        href: '/${_instance.apiVersion}/users/${id.uuid}',
        method: LinkMethodEnum.delete,
      ),
      LinksResponseDto(
        rel: LinkRelationEnum.list,
        href: '/${_instance.apiVersion}/users',
        method: LinkMethodEnum.get,
      ),
      LinksResponseDto(
        rel: LinkRelationEnum.create,
        href: '/${_instance.apiVersion}/users',
        method: LinkMethodEnum.post,
      ),
    ];
  }
}
