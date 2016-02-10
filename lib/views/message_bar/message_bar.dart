import 'package:angular2/angular2.dart';
import 'package:logging/logging.dart';
import 'package:polymer_elements/iron_flex_layout/classes/iron_flex_layout.dart';
import 'package:polymer_elements/paper_material.dart';

@Component(selector: 'message-bar',
    encapsulation: ViewEncapsulation.Native,
    templateUrl: 'message_bar.html'
)
class MessageBar {
  final Logger log;

  @Input() String message;
  @Input() String width;

  MessageBar(Logger this.log) {
    log.info("$runtimeType()");
  }
}