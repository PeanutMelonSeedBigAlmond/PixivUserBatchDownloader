// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_artworks_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserArtworksInfo _$UserArtworksInfoFromJson(Map<String, dynamic> json) =>
    UserArtworksInfo(
      _Body.fromJson(json['body'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserArtworksInfoToJson(UserArtworksInfo instance) =>
    <String, dynamic>{
      'body': instance.body,
    };

_Body _$BodyFromJson(Map<String, dynamic> json) => _Body(
      json['illusts'],
      json['manga'],
    );

Map<String, dynamic> _$BodyToJson(_Body instance) => <String, dynamic>{
      'illusts': instance.artworks,
      'manga': instance.manga,
    };
