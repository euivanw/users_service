import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';

import '../server_instance.dart';
import '../shared/core_router.dart';
import '../shared/json_response.dart';

class MainRoutes implements CoreRouter {
  final Logger _logger;
  final ServerInstance _instance;

  MainRoutes({required ServerInstance instance})
    : _instance = instance,
      _logger = Logger('MainRoutes');

  @override
  Future<void> configure() async {
    var route = '/';
    _instance.app.get(route, _handleMain);
    _logger.info('Registering route: GET    $route');

    route = '/${_instance.apiVersion}/';
    _instance.app.get(route, _handleMain);
    _logger.info('Registering route: GET    $route');
  }

  static Response _handleMain(Request request) {
    return JsonResponse.ok({'message': 'Welcome to the Users API.'});
  }
}
