import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:uuid/uuid_value.dart';

import '../../../../../usecase/users/get_all_users/get_all_users_input_dto.dart';
import '../../../../../usecase/users/get_all_users/get_all_users_usecase.dart';
import '../../../../database/users/users_repository_impl.dart';
import '../../server_instance.dart';
import '../../shared/core_router.dart';
import '../../shared/json_response.dart';
import '../../shared/link_method_enum.dart';
import '../../shared/link_relation_enum.dart';
import '../../shared/links_response_dto.dart';
import 'get_all_users_response_dto.dart';

final class GetAllUsersRoute implements CoreRouter {
  final Logger _logger;
  final ServerInstance _instance;
  final Connection _dbconn;

  GetAllUsersRoute({
    required ServerInstance instance,
    required Connection dbconn,
  }) : _instance = instance,
       _dbconn = dbconn,
       _logger = Logger('GetAllUsersRoute');

  @override
  Future<void> configure() async {
    final route = '/${_instance.apiVersion}/users';
    _instance.app.get(route, _getAllUsers);

    _logger.info('Registering route GET $route');
  }

  Future<Response> _getAllUsers(Request request) async {
    _logger.info('Fetching all users');

    final repository = UsersRepositoryImpl(connection: _dbconn);
    final usecase = GetAllUsersUsecase(repository: repository);
    final input = GetAllUsersInputDto();
    final users = await usecase.execute(input);

    return users.fold(
      ifLeft: (exception) {
        return JsonResponse.internalServerError(exception.businessMessage);
      },
      ifRight: (output) {
        GetAllUsersResponseDto responseDto = GetAllUsersResponseDto(
          users:
              output.users.map((user) {
                final links = _createLinks(user.id);
                return GetAllUsersResponseUserDto.fromOutputDto(user, links);
              }).toList(),
        );

        return JsonResponse.ok(responseDto.toMap());
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
