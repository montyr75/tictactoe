import 'package:angular/angular.dart';

import '../../services/logger_service.dart';

@Component(selector: 'message-bar',
    templateUrl: 'message_bar.html'
)
class MessageBar {
  final LoggerService _log;

  @Input() String message;

  MessageBar(LoggerService this._log) {
    _log.info("$runtimeType()");
  }
}