import 'dart:io';

import 'package:PixivUserDownload/utils/ugoira_merge_util_opencv.dart';

import 'config.dart';
import 'log_util.dart';

import 'network/client.dart';
import 'proxy_helper.dart';

import 'package:PixivUserDownload/utils/ugoira_unzip_util.dart';

late Client _client;

void main() async {
  LogUtil.i("=" * 32);
  await _init();
  await _initHttpClient();
  var uids = _readUids();
  uids.forEach((uid) async {
    LogUtil.i("正在下载uid:${uid}的作品");
    try {
      var userArtwork = await _getUserArtworksId(uid);
      for (var artworkId in userArtwork) {
        _client.getArtworkInfo(artworkId).then((value) async {
          var r18 = value.body.xRestrict == 1;
          var title = value.body.illustTitle;
          if (value.isUgoira()) {
            await _downloadUgoira(
                artworkId, r18, getImageStorageDir(r18, uid), title);
          } else {
            await _downloadNormalArtwork(
                artworkId, r18, getImageStorageDir(r18, uid), title);
          }
        }).onError((error, stackTrace) {
          LogUtil.e("获取插画$artworkId的信息失败:$error");
        });
      }
    } catch (err) {
      LogUtil.e("下载uid:${uid}的作品失败：$err");
    }
  });
}

_init() async {
  _checkFileExists("uid.txt");
  _setupCookie();
  await _initHttpClient();
}

List<String> _readUids() {
  var file = File("uid.txt");
  var lines = file.readAsLinesSync();
  lines.removeWhere((element) => element == "");
  return lines;
}

_checkFileExists(String fileName) {
  var file = File(fileName);
  if (!file.existsSync()) {
    LogUtil.e("$fileName 不存在，退出");
    exit(-1);
  }
}

_setupCookie() {
  _checkFileExists("cookie.txt");
  var file = File("cookie.txt");
  cookie = file.readAsStringSync().trim();
}

_initHttpClient() async {
  var proxy = await ProxyHelper.getSystemProxy();
  _client = Client(proxyString: proxy);
}

Future<List<String>> _getUserArtworksId(String uid) async {
  var response = await _client.getUserAllArtworks(uid);
  var illusts = response.body.artworks is Map<String, dynamic>
      ? response.body.artworks as Map<String, dynamic>
      : {};
  var ids = illusts.keys.toList();
  return Future(() => ids as List<String>);
}

Future _downloadNormalArtwork(
    String pid, bool r18, String path, String title) async {
  return _client.getArtworkPages(pid, r18).then((value) {
    for (var image in value.body) {
      var url = image.urls.original;
      var fileName = _getFileNameFromUrl(url, title);
      if (File("$path/$fileName").existsSync()) {
        LogUtil.v("${fileName}已经存在，跳过");
        continue;
      }
      _client
          .downloadImage(url, path, fileName)
          .then((value) => LogUtil.i("下载$fileName完成"))
          .onError((error, stackTrace) {
        LogUtil.e("$fileName下载失败：$error");
      });
    }
  }).onError((error, stackTrace) => LogUtil.e("获取$pid图片失败：$error"));
}

Future _downloadUgoira(String pid, bool r18, String path, String title) async {
  var fileName = _replaceBadCharFromFileName("(pid_$pid)${title}_ugoira.mp4");
  if (File(path + "/" + fileName).existsSync()) {
    LogUtil.v("$fileName已存在，跳过");
    return;
  }
  Map<String, int> durationInfo = Map<String, int>();
  return _client
      .getUgoiraMetadata(pid, r18)
      .then((value) {
        for (var f in value.body.frames) {
          durationInfo[f.file] = f.delay;
        }
        var zipUrl = value.body.originalSrc;
        return zipUrl;
      })
      .onError((error, stackTrace) => LogUtil.e("获取动图$pid信息失败：$error"))
      .then((value) async {
        LogUtil.i("正在下载$pid.zip");
        await _client.downloadUgoiraZip(value, "$tempDir", "$pid.zip");
      })
      .onError((error, stackTrace) => LogUtil.e("$pid.zip下载失败：$error"))
      .then((_) async {
        LogUtil.i("$pid.zip下载完成");
        return await UgoiraUnzipUtil.unzipFile(
            "$tempDir/$pid.zip", "$tempDir/$pid");
      })
      .onError((error, stackTrace) => LogUtil.e("解压$pid.zip失败"))
      .then((value) {
        var baseDir = value;
        var frames = <Frame>[];
        for (var k in durationInfo.keys) {
          var duration = durationInfo[k]!;
          frames.add(Frame("$baseDir/$k", duration));
        }
        return frames;
      })
      .then((value) async {
        LogUtil.i("正在合成动图：$pid");
        var file = File(path + "/" + fileName);
        var util = UgoiraMergeUtilOpenCV();
        return await util.merge(value, file.path);
      })
      .onError((error, stackTrace) => LogUtil.e("$pid 合成动图失败：$error"))
      .then((value) {
        LogUtil.i("下载$pid完成");
        File("$tempDir/$pid.zip").delete();
        Directory("$tempDir/$pid").delete(recursive: true);
      });
}

String getImageStorageDir(bool r18, String uid) =>
    r18 && splitR18 ? "$targetDir/$uid/$r18Dir" : "$targetDir/$uid";

String _getFileNameFromUrl(String url, String title) {
  var regex = RegExp("(\\d*)_p(\\d*)\\.([a-z]{3})");
  var match = regex.firstMatch(url) as RegExpMatch;
  var pid = match.group(1) as String;
  var page = match.group(2) as String;
  var extName = match.group(3) as String;
  return _replaceBadCharFromFileName("(pid-$pid)${title}_p${page}.$extName");
}

String _replaceBadCharFromFileName(String fileName) {
  var replacement = " ";
  return fileName.replaceAll(RegExp("[\/:*?\"<>\|]"), replacement);
}
