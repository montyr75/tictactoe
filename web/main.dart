library tic_tac_toe.web.main;

import 'dart:html';

import 'package:polymer_elements/iron_flex_layout/classes/iron_flex_layout.dart';
import 'package:polymer/polymer.dart';

import 'package:angular2/angular2.dart';
import 'package:angular2/bootstrap.dart';

import 'package:tic_tac_toe/views/main_app/main_app.dart';
import 'package:tic_tac_toe/services/logger.dart';

import 'package:logging/logging.dart';

const String APP_NAME = "tic_tac_toe";

final AppMode appMode = window.location.host.contains('localhost') ? AppMode.Develop : AppMode.Production;

final OpaqueToken AppNameToken = new OpaqueToken("AppNameToken");

main() async {
  await initPolymer();

  bootstrap(MainApp, [
    provide(AppNameToken, useValue: APP_NAME),
    provide(AppMode, useValue: appMode),
    provide(Logger, useFactory: (String name, AppMode mode) =>
        initLog(name, mode), deps: [AppNameToken, AppMode])
  ]);
}
