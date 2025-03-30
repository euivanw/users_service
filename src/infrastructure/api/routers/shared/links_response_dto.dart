import 'link_method_enum.dart';
import 'link_relation_enum.dart';

final class LinksResponseDto {
  final LinkRelationEnum _rel;
  final String _href;
  final LinkMethodEnum _method;

  const LinksResponseDto({
    required LinkRelationEnum rel,
    required String href,
    required LinkMethodEnum method,
  }) : _rel = rel,
       _href = href,
       _method = method;

  Map<String, dynamic> toMap() {
    return {'rel': _rel.name, 'href': _href, 'method': _method.name};
  }
}
