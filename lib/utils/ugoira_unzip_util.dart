import 'dart:io';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';

class UgoiraUnzipUtil {
  static Future<String> unzipFile(String fileName, String baseDir) async {
    var decoder = ZipDecoder().decodeBytes(File(fileName).readAsBytesSync());
    for (var file in decoder.files) {
      var fileName = file.name;
      var fileContent = file.content as List<int>;
      var f = File("$baseDir/$fileName");
      f
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileContent);
    }
    return Future.value(baseDir);
  }
}
