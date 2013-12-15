library main_view;

import 'dart:html';
import 'package:polymer/polymer.dart';
import '../../model/cell.dart';

@CustomTag('main-view')
class MainView extends PolymerElement {

  // constants
  static const String DEFAULT_MSG_CLASS = "label-default";
  static const String WIN_MSG_CLASS = "label-success";
  static const String TIE_MSG_CLASS = "label-important";

  // strings
  static const String DEFAULT_MSG = "Let's play, bitches!";
  static const String CONGRATS_MSG = "Fuck yeah!";
  static const String TIE_MSG = "Bloody hell! Another fuckin' tie. *sigh*";

  // game data
  @observable List<Cell> cellGrid;
  @observable String currentPlayer;
  int turnCount;

  // UI data
  @observable String gameStateMessage;
  @observable String messageClass;
  bool gridInterfaceEnabled;

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
      ['X', 'O', '_'],
      ['O', 'X', '_'],
      ['_', '_', 'X']
    ]);
  }

  void cellClicked(Event event, var detail, Element target) {
    print("MainView::cellClicked()");
  }

  // this lets the global CSS bleed through into the Shadow DOM of this element
  bool get applyAuthorStyles => true;
}

