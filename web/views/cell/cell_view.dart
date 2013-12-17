library cell_view;

import 'dart:html';
import 'package:polymer/polymer.dart';
import '../../model/cell.dart';

@CustomTag('cell-view')
class CellView extends TableCellElement with Polymer, Observable {
  @published Cell cell;
  @published String currentPlayer;
  @published bool gridInterfaceEnabled;

  @observable bool highlight = true;

  // we need this stuff because we're extending <td> instead of PolymerElement
  factory CellView() => new Element.tag('td', 'cell-view');
  CellView.created() : super.created() {
    polymerCreated();
  }

  void enteredView() {
    super.enteredView();
    //print("CellView::enteredView()");

    bindCssClass(this, 'highlight', this, 'cell.state == Cell.EMPTY_CELL');
  }

  void clicked(Event event, var detail, Element target) {
    if (gridInterfaceEnabled && cell.isEmpty) {
      cell.state = currentPlayer;
      dispatchEvent(new CustomEvent("cell-state-change"));
    }
  }

  // this lets the global CSS (such as Bootstrap, perhaps) bleed through into the Shadow DOM of this element
  // take it out if this is not desireable
  bool get applyAuthorStyles => true;
}
