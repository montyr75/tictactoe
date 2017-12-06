import 'dart:html';

import 'package:angular/angular.dart';

import 'package:tic_tac_toe/main_app.dart';
import 'package:tic_tac_toe/src/services/logger_service.dart';

const String APP_NAME = "tic_tac_toe";
final bool _debugMode = window.location.host.contains('localhost');
final LoggerService _log = new LoggerService(appName: APP_NAME, debugMode: _debugMode);

main() async {
  bootstrap(MainApp, [
    provide(LoggerService, useValue: _log)
  ]);
}