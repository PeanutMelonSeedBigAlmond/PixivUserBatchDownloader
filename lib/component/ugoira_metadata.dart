import 'package:json_annotation/json_annotation.dart';

part 'ugoira_metadata.g.dart';


@JsonSerializable()
class UgoiraMetadata extends Object {

  @JsonKey(name: 'error')
  bool error;

  @JsonKey(name: 'message')
  String message;

  @JsonKey(name: 'body')
  _Body body;

  UgoiraMetadata(this.error,this.message,this.body,);

  factory UgoiraMetadata.fromJson(Map<String, dynamic> srcJson) => _$UgoiraMetadataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UgoiraMetadataToJson(this);

}


@JsonSerializable()
class _Body extends Object {

  @JsonKey(name: 'src')
  String src;

  @JsonKey(name: 'originalSrc')
  String originalSrc;

  @JsonKey(name: 'mime_type')
  String mimeType;

  @JsonKey(name: 'frames')
  List<_Frames> frames;

  _Body(this.src,this.originalSrc,this.mimeType,this.frames,);

  factory _Body.fromJson(Map<String, dynamic> srcJson) => _$BodyFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BodyToJson(this);

}


@JsonSerializable()
class _Frames extends Object {

  @JsonKey(name: 'file')
  String file;

  @JsonKey(name: 'delay') // 单位：毫秒
  int delay;

  _Frames(this.file,this.delay,);

  factory _Frames.fromJson(Map<String, dynamic> srcJson) => _$FramesFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FramesToJson(this);

}
