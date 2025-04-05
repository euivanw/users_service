import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../server_instance.dart';

abstract class JsonResponse {
  static Response ok(Object? object) {
    return Response.ok(
      json.encode(object),
      headers: {'Content-Type': ServerInstance.contentType},
    );
  }

  static Response internalServerError(String errorMessage) {
    return Response.internalServerError(
      body: json.encode({'message': errorMessage}),
      headers: {'Content-Type': ServerInstance.contentType},
    );
  }

  static Response badRequest(String validationMessage) {
    return Response.badRequest(
      body: json.encode({'message': validationMessage}),
      headers: {'Content-Type': ServerInstance.contentType},
    );
  }

  static Response notFound(String validationMessage) {
    return Response.notFound(
      json.encode({'message': validationMessage}),
      headers: {'Content-Type': ServerInstance.contentType},
    );
  }

  static Response created(Object? object) {
    return Response(
      201,
      body: json.encode(object),
      headers: {'Content-Type': ServerInstance.contentType},
    );
  }
}
