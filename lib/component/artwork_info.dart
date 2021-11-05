import 'package:json_annotation/json_annotation.dart';

part 'artwork_info.g.dart';
@JsonSerializable()
class ArtworkInfo{
  _Body body;
  ArtworkInfo(this.body);
  factory ArtworkInfo.fromJson(Map<String,dynamic> json)=>_$ArtworkInfoFromJson(json);
  Map<String,dynamic> toJson()=>_$ArtworkInfoToJson(this);
}
@JsonSerializable()
class _Body{
  String illustId;
  String illustTitle;
  String id;
  int xRestrict;
  _Body(this.illustId,this.illustTitle,this.id,this.xRestrict);
  factory _Body.fromJson(Map<String,dynamic> json)=>_$BodyFromJson(json);
  Map<String,dynamic> toJson()=>_$BodyToJson(this);
}