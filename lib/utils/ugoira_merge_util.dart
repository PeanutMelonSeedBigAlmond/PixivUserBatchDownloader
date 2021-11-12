import 'dart:io';

import 'package:image/image.dart';

class UgoiraMergeUtil {
  static Future<List<int>> mergeGif(List<GifFrames> frames) async {
    return Future(() {
      var gifEncoder = GifEncoder();
      for (var frame in frames) {
        // 这里的时长单位是百分之一秒，api返回的单位是千分之一秒，所以要除以10
        gifEncoder.addFrame(frame.frameImage, duration: frame.duration ~/ 10);
      }
      var gifBytes = gifEncoder.finish() as List<int>;
      return gifBytes;
    });
  }
}

class GifFrames {
  Image frameImage;
  int duration;

  GifFrames(this.frameImage, this.duration);

  factory GifFrames.fromFile(String fileName, int duration) {
    late Decoder decoder;
    var fileExtName = _getImageExtName(fileName);
    var imageType = _switchImageType(fileExtName);
    switch (imageType) {
      case ImageType.JPEG:
        decoder = JpegDecoder();
        break;
      case ImageType.PNG:
        decoder = PngDecoder();
        break;
    }
    var image = decoder.decodeImage(File(fileName).readAsBytesSync()) as Image;
    return GifFrames(image, duration);
  }
}

enum ImageType { JPEG, PNG }

String _getImageExtName(String fileName) =>
    fileName.substring(fileName.indexOf("."));

ImageType _switchImageType(String extName) {
  late ImageType type;
  switch (extName) {
    case "png":
      type = ImageType.PNG;
      break;
    case "jpg":
    case "jpeg":
      type = ImageType.JPEG;
      break;
    default:
      type = ImageType.JPEG;
      break;
  }
  return type;
}
