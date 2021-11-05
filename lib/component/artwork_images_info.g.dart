// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artwork_images_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArtworkImagesInfo _$ArtworkImagesInfoFromJson(Map<String, dynamic> json) =>
    ArtworkImagesInfo(
      (json['body'] as List<dynamic>)
          .map((e) => _Body.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ArtworkImagesInfoToJson(ArtworkImagesInfo instance) =>
    <String, dynamic>{
      'body': instance.body,
    };

_Body _$BodyFromJson(Map<String, dynamic> json) => _Body(
      _Urls.fromJson(json['urls'] as Map<String, dynamic>),
      json['width'] as int,
      json['height'] as int,
    );

Map<String, dynamic> _$BodyToJson(_Body instance) => <String, dynamic>{
      'urls': instance.urls,
      'width': instance.width,
      'height': instance.height,
    };

_Urls _$UrlsFromJson(Map<String, dynamic> json) => _Urls(
      json['thumb_mini'] as String,
      json['small'] as String,
      json['regular'] as String,
      json['original'] as String,
    );

Map<String, dynamic> _$UrlsToJson(_Urls instance) => <String, dynamic>{
      'thumb_mini': instance.thumbMini,
      'small': instance.small,
      'regular': instance.regular,
      'original': instance.original,
    };
