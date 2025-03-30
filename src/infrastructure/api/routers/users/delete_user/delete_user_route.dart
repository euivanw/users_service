import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/validation.dart';

import '../../../../../usecase/users/delete_user/delete_user_input_dto.dart';
import '../../../../../usecase/users/delete_user/delete_user_usecase.dart';
import '../../../../database/users/users_repository_impl.dart';
import '../../server_instance.dart';
import '../../shared/core_router.dart';
import '../../shared/json_response.dart';
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
      return JsonResponse.badRequest('User ID must be a valid UUID.');
    }

    final repository = UsersRepositoryImpl(connection: _dbconn);
    final usecase = DeleteUserUsecase(repository: repository);
    final input = DeleteUserInputDto(id: UuidValue.fromString(userId));
    final deleted = await usecase.execute(input);

    return deleted.fold(
      ifLeft: (exception) {
        _logger.severe(
          'Error deleting user: ${exception.businessMessage}',
          exception,
        );
        return JsonResponse.internalServerError(exception.businessMessage);
      },
      ifRight: (output) {
        _logger.info('User deleted successfully: ${output.toString()}');
        return JsonResponse.ok(
          DeleteUserResponseDto.fromOutputDto(output).toMap(),
        );
      },
    );
  }
}
