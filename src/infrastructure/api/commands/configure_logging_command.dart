import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';

abstract class ConfigureLoggingCommand {
  static void configureLogging() {
    Logger.root.level = Level.INFO;

    Logger.root.onRecord.listen((logRecord) {
      if (logRecord.level >= Level.SEVERE) {
        stderr.writeln(
          json.encode({
            'time': logRecord.time.toIso8601String(),
            'sequenceNumber': logRecord.sequenceNumber,
            'level': logRecord.level.name,
            'logger': logRecord.loggerName,
            'message': logRecord.message,
            'error': logRecord.error?.toString(),
            'stackTrace': logRecord.stackTrace?.toString(),
          }),
        );
        return;
      }

      stdout.writeln(
        json.encode({
          'time': logRecord.time.toIso8601String(),
          'sequenceNumber': logRecord.sequenceNumber,
          'level': logRecord.level.name,
          'logger': logRecord.loggerName,
          'message': logRecord.message,
        }),
      );
    });
  }
}
