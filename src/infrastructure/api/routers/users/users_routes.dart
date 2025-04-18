import 'package:postgres/postgres.dart';

import '../server_instance.dart';
import '../shared/core_router.dart';
import 'create_user/create_user_route.dart';
import 'delete_user/delete_user_route.dart';
import 'get_all_users/get_all_users_route.dart';
import 'get_user_by_id/get_user_by_id_route.dart';
import 'update_user/update_user_route.dart';

final class UsersRoutes implements CoreRouter {
  final ServerInstance _instance;
  final Connection _dbconn;

  const UsersRoutes({
    required ServerInstance instance,
    required Connection dbconn,
  }) : _instance = instance,
       _dbconn = dbconn;

  @override
  Future<void> configure() async {
    GetAllUsersRoute(instance: _instance, dbconn: _dbconn).configure();
    CreateUserRoute(instance: _instance, dbconn: _dbconn).configure();
    UpdateUserRoute(instance: _instance, dbconn: _dbconn).configure();
    GetUserByIdRoute(instance: _instance, dbconn: _dbconn).configure();
    DeleteUserRoute(instance: _instance, dbconn: _dbconn).configure();
  }
}
