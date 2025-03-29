import 'package:test/test.dart';

import '../../src/shared/string_extension.dart';

void main() {
  group('StringExtension', () {
    group('formatSQL', () {
      test('should format SQL string with multiple spaces', () {
        const sql = 'SELECT   *   FROM   users';
        expect(sql.formatSQL, equals('SELECT * FROM users'));
      });

      test('should format SQL string with newlines and tabs', () {
        const sql = '''
          SELECT  *
          FROM    users
          WHERE   id = 1
        ''';
        expect(sql.formatSQL, equals('SELECT * FROM users WHERE id = 1'));
      });

      test('should trim leading and trailing spaces', () {
        const sql = '   SELECT * FROM users    ';
        expect(sql.formatSQL, equals('SELECT * FROM users'));
      });

      test('should handle empty string', () {
        const sql = '';
        expect(sql.formatSQL, equals(''));
      });

      test('should handle string with only whitespace', () {
        const sql = '   \n\t   \r\n   ';
        expect(sql.formatSQL, equals(''));
      });
    });
  });
}
