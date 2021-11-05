import 'package:json_annotation/json_annotation.dart';

part 'user_artworks_info.g.dart';

@JsonSerializable()
class UserArtworksInfo {
  _Body body;

  UserArtworksInfo(this.body);

  factory UserArtworksInfo.fromJson(Map<String, dynamic> json) =>
      _$UserArtworksInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserArtworksInfoToJson(this);
}

@JsonSerializable()
class _Body {
  /**
   * Fxxking Pixiv api
   * The field sometimes will be List, and sometimes will be Map
   */
  @JsonKey(name: "illusts")
  dynamic artworks;
  dynamic manga;

  _Body(this.artworks, this.manga);

  factory _Body.fromJson(Map<String, dynamic> json) => _$BodyFromJson(json);

  Map<String, dynamic> toJson() => _$BodyToJson(this);
}
