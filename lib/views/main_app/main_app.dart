library tic_tac_toe.lib.views.main_app;

import 'package:angular2/angular2.dart';
import 'package:logging/logging.dart';
import 'package:polymer_elements/iron_flex_layout/classes/iron_flex_layout.dart';
import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_elements/paper_header_panel.dart';
import 'package:polymer_elements/paper_toolbar.dart';
import 'package:polymer_elements/paper_icon_button.dart';

import '../../model/ttt_board.dart';
import '../board_view/board_view.dart';
import '../toolbar_view/toolbar_view.dart';

@Component(selector: 'main-app',
    encapsulation: ViewEncapsulation.Native,
    templateUrl: 'main_app.html',
    directives: const [BoardView, ToolbarView]
)
class MainApp {
  final Logger log;

  TTTBoard board;
  String currentPlayer;
  bool interfaceEnabled;
  int boardSize = 450;
  String message;

  MainApp(Logger this.log) {
    log.info("$runtimeType()");

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