import 'dart:io';

import 'config.dart';
import 'log_util.dart';

import 'network/client.dart';
import 'proxy_helper.dart';

late Client _client;

void main() async {
  LogUtil.i("=" * 32);
  _checkFileExists("uid.txt");
  _setupCookie();
  await _initHttpClient();
  var file = File("uid.txt");
  var lines = file.readAsLinesSync();
  lines.removeWhere((element) => element == "");
  lines.forEach((element) async {
    LogUtil.i("正在下载uid:${element}的作品");
    _getUserArtworksId(element).then((value) async {
      value.forEach((pid) async {
        await _downloadArtworkImages(element, pid);
      });
    }).onError((error, stackTrace) => LogUtil.e("uid:${element}作品信息获取失败"));
  });
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

Future _downloadArtworkImages(String uid, String pid) async {
  var artworkInfo = await _client.getArtworkInfo(pid);
  var r18 = artworkInfo.body.xRestrict == 1;
  var artworkImages = await _client.getArtworkPages(pid, r18);
  var targetDirectory = splitR18 && r18 ? "$targetDir/$uid/$r18Dir" : "$targetDir/$uid";
  artworkImages.body.forEach((element) {
    var url = element.urls.original;
    var fileName = _getFileNameFromUrl(url, artworkInfo.body.illustTitle);
    _client.downloadImage(url, targetDirectory, fileName)
        .then((value) => LogUtil.i("下载$targetDirectory/$fileName成功"))
    .onError((error, stackTrace) {
      if(error is String){
        LogUtil.w(error);
      }else{
        LogUtil.e("$fileName下载失败:$error");
      }
    });
  });
}

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
