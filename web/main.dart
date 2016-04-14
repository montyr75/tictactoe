import 'dart:html';

import 'package:polymer_elements/iron_flex_layout/classes/iron_flex_layout.dart';
import 'package:polymer/polymer.dart';

import 'package:angular2/angular2.dart';
import 'package:angular2/platform/browser.dart';

import 'package:tic_tac_toe/views/main_app/main_app.dart';
import 'package:tic_tac_toe/services/logger.dart';

import 'package:logging/logging.dart';

const String APP_NAME = "tic_tac_toe";
final bool debugMode = window.location.host.contains('localhost');

final Logger _log = initLog(APP_NAME, debugMode);

main() async {
  await initPolymer();

  bootstrap(MainApp, [
    provide(Logger, useValue: _log)
  ]);
}