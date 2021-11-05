// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artwork_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArtworkInfo _$ArtworkInfoFromJson(Map<String, dynamic> json) => ArtworkInfo(
      _Body.fromJson(json['body'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ArtworkInfoToJson(ArtworkInfo instance) =>
    <String, dynamic>{
      'body': instance.body,
    };

_Body _$BodyFromJson(Map<String, dynamic> json) => _Body(
      json['illustId'] as String,
      json['illustTitle'] as String,
      json['id'] as String,
      json['xRestrict'] as int,
    );

Map<String, dynamic> _$BodyToJson(_Body instance) => <String, dynamic>{
      'illustId': instance.illustId,
      'illustTitle': instance.illustTitle,
      'id': instance.id,
      'xRestrict': instance.xRestrict,
    };
