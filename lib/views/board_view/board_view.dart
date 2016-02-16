import 'package:angular2/angular2.dart';
import 'package:logging/logging.dart';
import 'package:polymer_elements/iron_flex_layout/classes/iron_flex_layout.dart';
import 'package:polymer_elements/paper_material.dart';

import '../../model/ttt_board.dart';

@Component(selector: 'board-view',
    encapsulation: ViewEncapsulation.Native,
    templateUrl: 'board_view.html'
)
class BoardView {
  final Logger log;

  @Input() TTTBoard model;
  @Input() String currentPlayer;
  @Input() bool interfaceEnabled;

  @Output() EventEmitter win = new EventEmitter<String>();
  @Output() EventEmitter tie = new EventEmitter();
  @Output() EventEmitter move = new EventEmitter();

  int boardSize;
  int squareSize;

  BoardView(Logger this.log) {
    log.info("$runtimeType()");
  }

  void squareSelected(int squareIndex) {
    log.info("$runtimeType::squareClicked -- $squareIndex");

    if (interfaceEnabled && model.isSquareEmpty(squareIndex)) {
      String winner = model.move(squareIndex, currentPlayer);

      if (winner != null) {
        win.emit(winner);
      }
      else if (model.isFull) {
        tie.emit(null);
      }
      else {
        move.emit(null);
      }
    }
  }

  @Input() void set size(int val) {
    boardSize = val;
    squareSize = boardSize ~/ 3;
  }

  Map get squareStyles => {
    "width": "${squareSize}px",
    "height": "${squareSize}px",
    "font-size": "${(squareSize * 0.8).round()}px"
  };
}