import 'package:uuid/uuid_value.dart';

import '../../shared/link_method_enum.dart';
import '../../shared/link_relation_enum.dart';
import '../../shared/links_response_dto.dart';

List<LinksResponseDto> createUserLinks(String apiVersion, UuidValue id) {
  return [
    LinksResponseDto(
      rel: LinkRelationEnum.self,
      href: '/$apiVersion/users/${id.uuid}',
      method: LinkMethodEnum.get,
    ),
    LinksResponseDto(
      rel: LinkRelationEnum.update,
      href: '/$apiVersion/users/${id.uuid}',
      method: LinkMethodEnum.put,
    ),
    LinksResponseDto(
      rel: LinkRelationEnum.delete,
      href: '/$apiVersion/users/${id.uuid}',
      method: LinkMethodEnum.delete,
    ),
    LinksResponseDto(
      rel: LinkRelationEnum.list,
      href: '/$apiVersion/users',
      method: LinkMethodEnum.get,
    ),
    LinksResponseDto(
      rel: LinkRelationEnum.create,
      href: '/$apiVersion/users',
      method: LinkMethodEnum.post,
    ),
  ];
}
