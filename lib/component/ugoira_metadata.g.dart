// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ugoira_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UgoiraMetadata _$UgoiraMetadataFromJson(Map<String, dynamic> json) =>
    UgoiraMetadata(
      json['error'] as bool,
      json['message'] as String,
      _Body.fromJson(json['body'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UgoiraMetadataToJson(UgoiraMetadata instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'body': instance.body,
    };

_Body _$BodyFromJson(Map<String, dynamic> json) => _Body(
      json['src'] as String,
      json['originalSrc'] as String,
      json['mime_type'] as String,
      (json['frames'] as List<dynamic>)
          .map((e) => _Frames.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BodyToJson(_Body instance) => <String, dynamic>{
      'src': instance.src,
      'originalSrc': instance.originalSrc,
      'mime_type': instance.mimeType,
      'frames': instance.frames,
    };

_Frames _$FramesFromJson(Map<String, dynamic> json) => _Frames(
      json['file'] as String,
      json['delay'] as int,
    );

Map<String, dynamic> _$FramesToJson(_Frames instance) => <String, dynamic>{
      'file': instance.file,
      'delay': instance.delay,
    };
