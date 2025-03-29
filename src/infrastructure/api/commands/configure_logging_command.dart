import 'dart:io';

import 'package:logging/logging.dart';

abstract class ConfigureLoggingCommand {
  static void configureLogging() {
    Logger.root.level = Level.INFO;

    Logger.root.onRecord.listen((record) {
      stdout.writeln(
        '${record.time.toIso8601String()} : ${record.level.name} : ${record.message}',
      );
    });
  }
}
