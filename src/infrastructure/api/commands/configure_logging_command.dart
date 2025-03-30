import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';

abstract class ConfigureLoggingCommand {
  static void configureLogging() {
    Logger.root.level = Level.INFO;

    Logger.root.onRecord.listen((record) {
      stdout.writeln(
        json.encode({
          'time': record.time.toIso8601String(),
          'sequenceNumber': record.sequenceNumber,
          'level': record.level.name,
          'logger': record.loggerName,
          'message': record.message,
          'error': record.error?.toString(),
          'stackTrace': record.stackTrace?.toString(),
        }),
      );
    });
  }
}
