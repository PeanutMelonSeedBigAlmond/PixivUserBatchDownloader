import 'package:json_annotation/json_annotation.dart';

part 'artwork_images_info.g.dart';

@JsonSerializable()
class ArtworkImagesInfo{
  List<_Body> body;
  ArtworkImagesInfo(this.body);
  factory ArtworkImagesInfo.fromJson(Map<String,dynamic> json)=>_$ArtworkImagesInfoFromJson(json);
  Map<String,dynamic> toJson()=>_$ArtworkImagesInfoToJson(this);
}

@JsonSerializable()
class _Body{
  _Urls urls;
  int width;
  int height;
  _Body(this.urls, this.width, this.height);
  factory _Body.fromJson(Map<String,dynamic> json)=>_$BodyFromJson(json);
  Map<String,dynamic> toJson()=>_$BodyToJson(this);
}

@JsonSerializable()
class _Urls{
  @JsonKey(name:"thumb_mini")
  String thumbMini;
  String small;
  String regular;
  String original;
  _Urls(this.thumbMini, this.small, this.regular, this.original);
  factory _Urls.fromJson(Map<String,dynamic> json)=>_$UrlsFromJson(json);
  Map<String,dynamic> toJson()=>_$UrlsToJson(this);
}