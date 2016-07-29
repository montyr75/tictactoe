import 'dart:html';

import 'package:polymer_elements/iron_flex_layout/classes/iron_flex_layout.dart';
import 'package:polymer/polymer.dart';

import 'package:angular2/angular2.dart';
import 'package:angular2/platform/browser.dart';

import 'package:tic_tac_toe/views/main_app/main_app.dart';
import 'package:tic_tac_toe/services/logger_service.dart';

const String APP_NAME = "tic_tac_toe";
final bool _debugMode = window.location.host.contains('localhost');
final LoggerService _log = new LoggerService(appName: APP_NAME, debugMode: _debugMode);

main() async {
  await initPolymer();

  bootstrap(MainApp, [
    provide(LoggerService, useValue: _log)
  ]);
}