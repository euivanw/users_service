import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/validation.dart';

import '../../../../../usecase/users/delete_user/delete_user_input_dto.dart';
import '../../../../../usecase/users/delete_user/delete_user_usecase.dart';
import '../../../../database/users/user_not_found_exception.dart';
import '../../../../database/users/users_repository_impl.dart';
import '../../server_instance.dart';
import '../../shared/core_router.dart';
import '../../shared/json_response.dart';
import '../../shared/link_method_enum.dart';
import '../../shared/link_relation_enum.dart';
import '../../shared/links_response_dto.dart';
import 'delete_user_response_dto.dart';

final class DeleteUserRoute implements CoreRouter {
  final Logger _logger;
  final ServerInstance _instance;
  final Connection _dbconn;

  DeleteUserRoute({
    required ServerInstance instance,
    required Connection dbconn,
  }) : _instance = instance,
       _dbconn = dbconn,
       _logger = Logger('DeleteUserRoute');

  @override
  Future<void> configure() async {
    final route = '/${_instance.apiVersion}/users/<userId>';
    _instance.app.delete(route, _deleteUser);

    _logger.info('Registering route DELETE $route');
  }

  Future<Response> _deleteUser(Request request, String userId) async {
    _logger.info('Deleting user with ID: $userId');

    if (!UuidValidation.isValidUUID(fromString: userId)) {
      return JsonResponse.badRequest('User ID [$userId] must be a valid UUID.');
    }

    final repository = UsersRepositoryImpl(connection: _dbconn);
    final usecase = DeleteUserUsecase(repository: repository);
    final input = DeleteUserInputDto(id: UuidValue.fromString(userId));
    final deleted = await usecase.execute(input);

    return deleted.fold(
      ifLeft: (exception) {
        if (exception is UserNotFoundException) {
          return JsonResponse.notFound(exception.businessMessage);
        }

        return JsonResponse.internalServerError(exception.businessMessage);
      },
      ifRight: (output) {
        final links = _createLinks(output.id);
        final deletedUser = DeleteUserResponseDto.fromOutputDto(output, links);

        return JsonResponse.ok(deletedUser.toMap());
      },
    );
  }

  List<LinksResponseDto> _createLinks(UuidValue id) {
    return [
      LinksResponseDto(
        rel: LinkRelationEnum.self,
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
