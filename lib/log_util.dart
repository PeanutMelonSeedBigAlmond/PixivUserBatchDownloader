import 'dart:io';

class LogUtil {
  static late String _logFileName = "Log.log";

  static i(String message, {bool printToFile = true}) {
    var log = "${_getNowTime()}\tINFO\t$message";
    if (printToFile) {
      var file = File(_logFileName);
      file.writeAsStringSync(log + "\n", mode: FileMode.append, flush: true);
    }
    print(log);
  }

  static w(String message, {bool printToFile = true}) {
    var log = "${_getNowTime()}\tWARNING\t$message";
    if (printToFile) {
      var file = File(_logFileName);
      file.writeAsStringSync(log + "\n", mode: FileMode.append, flush: true);
    }
    print(log);
  }

  static e(String message, {bool printToFile = true}) {
    var log = "${_getNowTime()}\tERROR\t$message";
    if (printToFile) {
      var file = File(_logFileName);
      file.writeAsStringSync(log + "\n", mode: FileMode.append, flush: true);
    }
    print(log);
  }

  static v(String message, {bool printToFile = false}) {
    var log = "${_getNowTime()}\tVERBOSE\t$message";
    if (printToFile) {
      var file = File(_logFileName);
      file.writeAsStringSync(log + "\n", mode: FileMode.append, flush: true);
    }
    print(log);
  }

  static String _getNowTime() {
    var now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, "0")}-${now.day} ${now.hour}:${now.minute}:${now.second}";
  }
}
