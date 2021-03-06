import 'dart:io';
import 'dart:typed_data';

import 'package:PixivUserDownload/component/ugoira_metadata.dart';
import 'package:PixivUserDownload/network/pixivcat_interceptor.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

import '../component/user_artworks_info.dart';
import '../component/artwork_info.dart';
import '../component/artwork_images_info.dart';
import 'client_interceptor.dart';

class Client {
  late Dio _dio;

  static const PIXIV_HOST_IP = "https://210.140.131.219";

  // 下载动图zip时的分块大小
  static const FILE_THUNK_SIZE = 4 * 1024 * 1024;

  Client() {
    // Thanks for @Notsfsssf
    // https://github.com/Notsfsssf/pixez-flutter/issues/63
    var options = BaseOptions(baseUrl: PIXIV_HOST_IP, headers: {
      "host": "www.pixiv.net",
      "referer": "https://www.pixiv.net/",
      "user-agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36",
      "accept-language": "zh-CN,zh;q=0.9,en;q=0.8,ja;q=0.7,zh-TW;q=0.6"
    });
    _dio = Dio(options);
    _dio.interceptors
      ..add(MyInterceptor())
      ..add(PixivCatInterceptor());
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (_, __, ___) => true;
      return client;
    };
  }

  Future<ArtworkInfo> getArtworkInfo(String pid) async {
    var url = "/ajax/illust/${pid}?lang=zh";
    var response = await _dio.get(url);
    return Future<ArtworkInfo>(() => ArtworkInfo.fromJson(response.data));
  }

  Future<ArtworkImagesInfo> getArtworkPages(String pid, bool r18) async {
    var url = "/ajax/illust/${pid}/pages?lang=zh";
    var option = Options(extra: {"needCookie": r18});
    var response = await _dio.get(url, options: option);
    return Future(() => ArtworkImagesInfo.fromJson(response.data));
  }

  Future<UserArtworksInfo> getUserAllArtworks(String uid) async {
    var url = "/ajax/user/${uid}/profile/all?lang=zh";
    var option = Options(extra: {"needCookie": true});
    var response = await _dio.get(url, options: option);
    return Future(() => UserArtworksInfo.fromJson(response.data));
  }

  Future<UgoiraMetadata> getUgoiraMetadata(String pid, bool r18) async {
    var url = "/ajax/illust/${pid}/ugoira_meta";
    var option = Options(extra: {"needCookie": r18});
    var response = await _dio.get(url, options: option);
    return Future(() => UgoiraMetadata.fromJson(response.data));
  }

  Future downloadImage(String url, String path, String fileName) async {
    var directory = Directory(path);
    if (!directory.existsSync()) {
      directory.create(recursive: true);
    }
    await _dio.download(url, "$path/$fileName");
  }

  Future downloadUgoiraZip(String url, String path, String saveFileName) async {
    var size = await _getResourceSize(url);
    var count = size ~/ FILE_THUNK_SIZE;
    var remain = size % FILE_THUNK_SIZE;
    var file = File("$path/$saveFileName").openSync(mode: FileMode.write);

    var tasks = <Future<Response<List<int>>>>[];
    var start = 0;
    var end = 0;
    var i = 0;
    for (; i < count; i++) {
      start = i * FILE_THUNK_SIZE;
      end = start + FILE_THUNK_SIZE - 1;
      var f = _downloadFilePart(url, start, end);
      tasks.add(f);
    }
    start = i * FILE_THUNK_SIZE;
    end = start + remain - 1;
    var f = _downloadFilePart(url, start, end);
    tasks.add(f);
    var result = await Future.wait(tasks);
    for (var res in result) {
      file.writeFromSync(res.data!);
    }
    file.close();
  }

  Future<int> _getResourceSize(String url) async {
    var response = await _dio.head(url);
    var size = response.headers.value("content-length")!;
    return Future.value(int.parse(size));
  }

  Future<Response<List<int>>> _downloadFilePart(
      String url, int start, int end) async {
    return await _dio.get<List<int>>(url,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {"Range": "bytes=$start-$end"},
        ));
  }
}
