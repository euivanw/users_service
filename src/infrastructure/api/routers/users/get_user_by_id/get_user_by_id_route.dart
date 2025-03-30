import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/validation.dart';

import '../../../../../usecase/users/get_user_by_id/get_user_by_id_input_dto.dart';
import '../../../../../usecase/users/get_user_by_id/get_user_by_id_usecase.dart';
import '../../../../database/users/user_not_found_exception.dart';
import '../../../../database/users/users_repository_impl.dart';
import '../../server_instance.dart';
import '../../shared/core_router.dart';
import '../../shared/json_response.dart';
import '../shared/create_links_function.dart';
import 'get_user_by_id_response_dto.dart';

final class GetUserByIdRoute implements CoreRouter {
  final Logger _logger;
  final ServerInstance _instance;
  final Connection _dbconn;

  GetUserByIdRoute({
    required ServerInstance instance,
    required Connection dbconn,
  }) : _instance = instance,
       _dbconn = dbconn,
       _logger = Logger('GetUserByIdRoute');

  @override
  Future<void> configure() async {
    final route = '/${_instance.apiVersion}/users/<userId>';
    _instance.app.get(route, _getUserById);

    _logger.info('Registering route GET $route');
  }

  Future<Response> _getUserById(Request request, String userId) async {
    if (!UuidValidation.isValidUUID(fromString: userId)) {
      return JsonResponse.badRequest('User ID [$userId] must be a valid UUID.');
    }

    _logger.info('Fetching user with ID: $userId');

    final repository = UsersRepositoryImpl(connection: _dbconn);
    final usecase = GetUserByIdUsecase(repository: repository);
    final id = UuidValue.fromString(userId);
    final input = GetUserByIdInputDto(id: id);
    final user = await usecase.execute(input);

    return user.fold(
      ifLeft: (exception) {
        if (exception is UserNotFoundException) {
          return JsonResponse.notFound(exception.businessMessage);
        }

        return JsonResponse.internalServerError(exception.businessMessage);
      },
      ifRight: (output) {
        final links = createUserLinks(_instance.apiVersion, output.id);
        final user = GetUserByIdResponseDto.fromOutputDto(output, links);

        return JsonResponse.ok(user.toMap());
      },
    );
  }
}
