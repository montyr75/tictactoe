library cell;

import 'package:polymer/polymer.dart';

class Cell extends Observable {
  static const String EMPTY_CELL = "";
  static const String PLAYER_1 = "X";
  static const String PLAYER_2 = "O";

  @observable String state = EMPTY_CELL;

  bool get isEmpty => state == EMPTY_CELL;

  @override String toString() => state;
}

class CellPoint {
  int row;
  int col;

  CellPoint(int this.row, int this.col);

  String toString() => "row: $row, col: $col";
}