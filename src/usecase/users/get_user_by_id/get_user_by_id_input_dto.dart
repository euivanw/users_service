import 'package:uuid/uuid.dart';

final class GetUserByIdInputDto {
  final UuidValue _id;

  const GetUserByIdInputDto({required UuidValue id}) : _id = id;

  UuidValue get id => _id;
}
