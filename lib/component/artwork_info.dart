import 'package:json_annotation/json_annotation.dart';

part 'artwork_info.g.dart';

@JsonSerializable()
class ArtworkInfo {
  _Body body;

  ArtworkInfo(this.body);

  factory ArtworkInfo.fromJson(Map<String, dynamic> json) =>
      _$ArtworkInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ArtworkInfoToJson(this);

  bool isUgoira() => body.illustType == 2;
}

@JsonSerializable()
class _Body {
  String illustId;
  String illustTitle;

  // 0为普通图片，2为动图
  int illustType;
  String id;
  int xRestrict;

  _Body(this.illustId, this.illustTitle, this.illustType, this.id,
      this.xRestrict);

  factory _Body.fromJson(Map<String, dynamic> json) => _$BodyFromJson(json);

  Map<String, dynamic> toJson() => _$BodyToJson(this);
}
