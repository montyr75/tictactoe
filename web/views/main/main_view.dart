library main_view;

import 'dart:html';
import 'package:polymer/polymer.dart';
import '../../model/cell.dart';

@CustomTag('main-view')
class MainView extends PolymerElement {

  // constants
  static const int MAX_MOVES = 9;
  static const String DEFAULT_MSG_CLASS = "label-default";
  static const String WIN_MSG_CLASS = "label-success";
  static const String TIE_MSG_CLASS = "label-warning";

  // strings
  static const String DEFAULT_MSG = "Let's play!";
  static const String CONGRATS_MSG = "Yeah!";
  static const String TIE_MSG = "Ah, hell! A friggin' tie. *sigh*";

  // game data
  @observable List<List<Cell>> cellGrid;
  @observable String currentPlayer;
  int turnCount;

  // win patterns
  final List<List<CellPoint>> winPatterns = [
    [new CellPoint(0, 0), new CellPoint(0, 1), new CellPoint(0, 2)],  // row 1
    [new CellPoint(1, 0), new CellPoint(1, 1), new CellPoint(1, 2)],  // row 2
    [new CellPoint(2, 0), new CellPoint(2, 1), new CellPoint(2, 2)],  // row 3
    [new CellPoint(0, 0), new CellPoint(1, 0), new CellPoint(2, 0)],  // col 1
    [new CellPoint(0, 1), new CellPoint(1, 1), new CellPoint(2, 1)],  // col 2
    [new CellPoint(0, 2), new CellPoint(1, 2), new CellPoint(2, 2)],  // col 3
    [new CellPoint(0, 0), new CellPoint(1, 1), new CellPoint(2, 2)],  // diag 1
    [new CellPoint(0, 2), new CellPoint(1, 1), new CellPoint(2, 0)]   // diag 2
  ];

  // UI data
  @observable String gameStateMessage;
  @observable String messageClass;
  @observable bool gridInterfaceEnabled;

  // non-visual initialization can be done here
  MainView.created() : super.created();

  // other initialization can be done here
  @override void enteredView() {
    super.enteredView();
    print("MainView::enteredView()");

    newGame();
  }

  void newGame() {
    print("MainView::newGame()");

    // set new game defaults
    turnCount = 0;
    currentPlayer = Cell.PLAYER_1;
    gridInterfaceEnabled = true;
    gameStateMessage = DEFAULT_MSG;
    messageClass = DEFAULT_MSG_CLASS;

    // create new blank grid
    cellGrid = toObservable([
      [new Cell(), new Cell(), new Cell()],
      [new Cell(), new Cell(), new Cell()],
      [new Cell(), new Cell(), new Cell()]
    ]);
  }

  void processTurn(Event event, var detail, Element target) {
    print("MainView::processTurn()");

    // count this turn
    turnCount++;

    // if there is a winner or a tie, end the game -- otherwise, just switch turns
    // NOTE: A win cannot occur before there have been 5 moves
    if (turnCount >= 5 && checkWin()) {
      gameStateMessage = "$CONGRATS_MSG Player $currentPlayer wins!";
      messageClass = WIN_MSG_CLASS;
      gridInterfaceEnabled = false;
    }
    else if (turnCount >= MAX_MOVES) {
      gameStateMessage = TIE_MSG;
      messageClass = TIE_MSG_CLASS;
      gridInterfaceEnabled = false;
    }
    else {
      currentPlayer = (currentPlayer == Cell.PLAYER_1) ? Cell.PLAYER_2 : Cell.PLAYER_1;
    }
  }

  bool checkWin() {
    for (List<CellPoint> winPattern in winPatterns) {
      Cell cell1 = cellGrid[winPattern[0].row][winPattern[0].col];
      Cell cell2 = cellGrid[winPattern[1].row][winPattern[1].col];
      Cell cell3 = cellGrid[winPattern[2].row][winPattern[2].col];

      // if all three cells match and aren't empty, there's a win
      if (!cell1.state.isEmpty && cell1.state == cell2.state && cell2.state == cell3.state) {
        return true;
      }
    }

    // if we get here, there is no win
    return false;
  }

  // this lets the global CSS bleed through into the Shadow DOM of this element
  bool get applyAuthorStyles => true;
}

