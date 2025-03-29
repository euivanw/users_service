import 'package:uuid/uuid.dart';

final class DeleteUserInputDto {
  final UuidValue _id;

  const DeleteUserInputDto({required UuidValue id}) : _id = id;

  UuidValue get id => _id;

  @override
  String toString() {
    return '''
      DeleteUserInputDto{
        id: $_id
      }
    ''';
  }
}
