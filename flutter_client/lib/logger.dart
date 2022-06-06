import 'package:logger/logger.dart';

Logger getLogger(String className) {
  return Logger(printer: MyPrinter(className));
}

class MyPrinter extends LogPrinter {
  final String className;
  MyPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    var color = PrettyPrinter.levelColors[event.level];
    return [color!("[$className - ${event.level.name}]: ${event.message}")];
  }
}
