library cell_view;

import 'dart:html';
import 'package:polymer/polymer.dart';
import '../../model/cell.dart';

@CustomTag('cell-view')
class CellView extends TableCellElement with Polymer, Observable {
  @published Cell cell;

  // we need this stuff because we're extending <td> instead of PolymerElement
  factory CellView() => new Element.tag('td', 'cell-view');
  CellView.created() : super.created() {
    polymerCreated();
  }

  void enteredView() {
    super.enteredView();
    print("CellView::enteredView()");
  }

  void clicked(Event event, var detail, Element target) {
    print("CellView::clicked()");

    //if (cell.isEmpty) {
    cell.state = Cell.PLAYER_1;
    //}
  }

  // this lets the global CSS (such as Bootstrap, perhaps) bleed through into the Shadow DOM of this element
  // take it out if this is not desireable
  bool get applyAuthorStyles => true;
}
