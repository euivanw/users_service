import 'package:dart_either/dart_either.dart' show Either;

abstract interface class Usecase<I, O, E> {
  Future<Either<E, O>> execute(I input);
}
