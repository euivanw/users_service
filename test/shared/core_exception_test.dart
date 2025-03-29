import 'package:test/test.dart';

import '../../src/shared/core_exception.dart';

void main() {
  group('CoreException', () {
    final businessMessage = 'Business error occurred';
    final technicalMessage = 'Technical error details';
    final stackTrace = StackTrace.current;

    test('should correctly assign businessMessage', () {
      final exception = CoreException(businessMessage: businessMessage);

      expect(exception.businessMessage, businessMessage);
    });

    test('should correctly assign technicalMessage', () {
      final exception = CoreException(
        businessMessage: businessMessage,
        technicalMessage: technicalMessage,
      );

      expect(exception.technicalMessage, technicalMessage);
    });

    test('should correctly assign stackTrace', () {
      final exception = CoreException(
        businessMessage: businessMessage,
        stackTrace: stackTrace,
      );

      expect(exception.stackTrace, stackTrace);
    });

    test('should handle null technicalMessage and stackTrace', () {
      final exception = CoreException(businessMessage: businessMessage);

      expect(exception.technicalMessage, isNull);
      expect(exception.stackTrace, isNull);
    });

    test('should format toString with only businessMessage', () {
      final exception = CoreException(businessMessage: businessMessage);

      expect(
        exception.toString(),
        contains('businessMessage: $businessMessage'),
      );
      expect(exception.toString(), contains('technicalMessage: null'));
      expect(exception.toString(), contains('stackTrace: null'));
    });

    test('should format toString with all fields', () {
      final exception = CoreException(
        businessMessage: businessMessage,
        technicalMessage: technicalMessage,
        stackTrace: stackTrace,
      );

      expect(
        exception.toString(),
        contains('businessMessage: $businessMessage'),
      );
      expect(
        exception.toString(),
        contains('technicalMessage: $technicalMessage'),
      );
      expect(exception.toString(), contains('stackTrace: $stackTrace'));
    });

    test('should be immutable with const constructor', () {
      const exception1 = CoreException(businessMessage: 'test');
      const exception2 = CoreException(businessMessage: 'test');

      expect(identical(exception1, exception2), isTrue);
    });

    test('should create instance with all parameters', () {
      final exception = CoreException(
        businessMessage: businessMessage,
        technicalMessage: technicalMessage,
        stackTrace: stackTrace,
      );

      expect(exception.businessMessage, businessMessage);
      expect(exception.technicalMessage, technicalMessage);
      expect(exception.stackTrace, stackTrace);
    });
  });
}
