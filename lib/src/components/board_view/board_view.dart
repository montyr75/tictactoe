import 'dart:async';

import 'package:angular/angular.dart';

import '../../services/logger_service.dart';
import '../../models/ttt_board.dart';

@Component(selector: 'board-view',
    templateUrl: 'board_view.html',
    directives: const [CORE_DIRECTIVES]
)
class BoardView {
  final LoggerService _log;

  @Input() TTTBoard model;
  @Input() String currentPlayer;
  @Input() bool interfaceEnabled;

  final StreamController<String> _win = new StreamController<String>.broadcast();
  @Output() Stream<String> get win => _win.stream;

  final StreamController _tie = new StreamController.broadcast();
  @Output() Stream get tie => _tie.stream;

  final StreamController _move = new StreamController.broadcast();
  @Output() Stream get move => _move.stream;

  BoardView(LoggerService this._log) {
    _log.info("$runtimeType()");
  }

  void cellSelected(int cellIndex) {
    _log.info("$runtimeType::cellSelected -- $cellIndex");

    if (interfaceEnabled && model.isCellEmpty(cellIndex)) {
      String winner = model.move(cellIndex, currentPlayer);

      if (winner != null) {
        _win.add(winner);
      }
      else if (model.isFull) {
        _tie.add(null);
      }
      else {
        _move.add(null);
      }
    }
  }
}