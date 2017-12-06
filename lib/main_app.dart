import 'package:angular/angular.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';

import 'src/services/logger_service.dart';
import 'src/models/ttt_board.dart';
import 'src/components/board_view/board_view.dart';
import 'src/components/message_bar/message_bar.dart';

@Component(selector: 'main-app',
    templateUrl: 'main_app.html',
    directives: const [
      BoardView,
      MessageBar,
      MaterialButtonComponent,
      MaterialIconComponent
    ],
    styleUrls: const ['package:angular_components/app_layout/layout.scss.css']
)
class MainApp {
  final LoggerService _log;

  TTTBoard board;
  String currentPlayer;
  bool interfaceEnabled;
  String message;

  MainApp(LoggerService this._log) {
    _log.info("$runtimeType()");

    newGame();
  }

  void newGame() {
    board = new TTTBoard();
    currentPlayer = null;
    interfaceEnabled = true;

    nextTurn();
  }

  void nextTurn() {
    currentPlayer = currentPlayer == "X" ? "O" : "X";
    message = "Player: $currentPlayer";
  }

  void onWin(String winner) {
    interfaceEnabled = false;
    message = "$currentPlayer wins!";
  }

  void onTie() {
    interfaceEnabled = false;
    message = "It's a tie!";
  }
}