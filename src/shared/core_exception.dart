import 'dart:convert';

class CoreException implements Exception {
  final String _businessMessage;
  final String? _technicalMessage;
  final StackTrace? _stackTrace;

  const CoreException({
    required String businessMessage,
    String? technicalMessage,
    StackTrace? stackTrace,
  }) : _businessMessage = businessMessage,
       _technicalMessage = technicalMessage,
       _stackTrace = stackTrace;

  String get businessMessage => _businessMessage;

  String? get technicalMessage => _technicalMessage;

  StackTrace? get stackTrace => _stackTrace;

  @override
  String toString() {
    return json.encode({
      'businessMessage': _businessMessage,
      'technicalMessage': _technicalMessage,
      'stackTrace': _stackTrace?.toString(),
    });
  }
}
