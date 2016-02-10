import 'package:angular2/angular2.dart';
import 'package:logging/logging.dart';
import 'package:polymer_elements/iron_flex_layout/classes/iron_flex_layout.dart';
import 'package:polymer_elements/paper_material.dart';

@Component(selector: 'toolbar-view',
    encapsulation: ViewEncapsulation.Native,
    templateUrl: 'toolbar_view.html'
)
class ToolbarView {
  final Logger log;

  @Input() String message;
  @Input() String width;

  ToolbarView(Logger this.log) {
    log.info("$runtimeType()");
  }
}