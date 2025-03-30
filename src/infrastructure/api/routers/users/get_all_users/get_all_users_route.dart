import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';

import '../../../../../usecase/users/get_all_users/get_all_users_input_dto.dart';
import '../../../../../usecase/users/get_all_users/get_all_users_usecase.dart';
import '../../../../database/users/users_repository_impl.dart';
import '../../server_instance.dart';
import '../../shared/core_router.dart';
import '../../shared/json_response.dart';
import '../shared/create_links_function.dart';
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
                final links = createUserLinks(_instance.apiVersion, user.id);
                return GetAllUsersResponseUserDto.fromOutputDto(user, links);
              }).toList(),
        );

        return JsonResponse.ok(responseDto.toMap());
      },
    );
  }
}
