library lib.services.logger;

import 'package:logging/logging.dart';
import 'package:intl/intl.dart' show DateFormat;

enum AppMode {
  Production,
  Develop
}

Logger initLog(String appName, AppMode appMode) {
  DateFormat dateFormatter = new DateFormat("H:m:s.S");

  Logger.root.level = Level.ALL;

  if (appMode == AppMode.Develop) {
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.level.name} (${dateFormatter.format(rec.time)}): ${rec.message}');
    });
  }

  return new Logger(appName);
}