import 'package:angular2/angular2.dart';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart' show DateFormat;

class LoggerService {
  Logger _log;
  final String appName;
  final bool debugMode;

  LoggerService({this.appName: "my_app", this.debugMode: true}) {
    DateFormat dateFormatter = new DateFormat("H:m:s.S");

    Logger.root.level = Level.ALL;

    if (debugMode) {
      Logger.root.onRecord.listen((LogRecord rec) {
        print('${rec.level.name} (${dateFormatter.format(rec.time)}): ${rec.message}');
      });
    }

    _log = new Logger(appName);
  }

  /** Log message at level [Level.FINEST]. */
  void finest(message, [Object error, StackTrace stackTrace]) =>
      _log.finest(message, error, stackTrace);

  /** Log message at level [Level.FINER]. */
  void finer(message, [Object error, StackTrace stackTrace]) =>
      _log.finer(message, error, stackTrace);

  /** Log message at level [Level.FINE]. */
  void fine(message, [Object error, StackTrace stackTrace]) =>
      _log.fine(message, error, stackTrace);

  /** Log message at level [Level.CONFIG]. */
  void config(message, [Object error, StackTrace stackTrace]) =>
      _log.config(message, error, stackTrace);

  /** Log message at level [Level.INFO]. */
  void info(message, [Object error, StackTrace stackTrace]) =>
      _log.info(message, error, stackTrace);

  /** Log message at level [Level.WARNING]. */
  void warning(message, [Object error, StackTrace stackTrace]) =>
      _log.warning(message, error, stackTrace);

  /** Log message at level [Level.SEVERE]. */
  void severe(message, [Object error, StackTrace stackTrace]) =>
      _log.severe(message, error, stackTrace);

  /** Log message at level [Level.SHOUT]. */
  void shout(message, [Object error, StackTrace stackTrace]) =>
      _log.shout(message, error, stackTrace);
}
