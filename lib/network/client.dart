import 'dart:io';

import 'package:PixivUserDownload/component/ugoira_metadata.dart';
import 'package:dio_http/adapter.dart';
import 'package:dio_http/dio_http.dart';

import '../component/user_artworks_info.dart';
import '../component/artwork_info.dart';
import '../component/artwork_images_info.dart';
import 'client_interceptor.dart';

class Client {
  late Dio _dio;

  Client({String proxyString = "DIRECT"}) {
    var options = BaseOptions(baseUrl: "https://www.pixiv.net/", headers: {
      "referer": "https://www.pixiv.net/",
      "user-agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36",
      "accept-language": "zh-CN,zh;q=0.9,en;q=0.8,ja;q=0.7,zh-TW;q=0.6"
    });
    _dio = Dio(options);
    _dio.interceptors.add(MyInterceptor());
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.findProxy = (uri) {
        return proxyString;
      };
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

  Future downloadUgoiraZip(String url,String path,String saveFileName) async {
    return await _dio.download(url, "$path/$saveFileName");
  }
}
