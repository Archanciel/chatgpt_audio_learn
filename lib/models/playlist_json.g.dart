// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaylistJson _$PlaylistJsonFromJson(Map<String, dynamic> json) => PlaylistJson(
      url: json['url'] as String,
      isSelected: json['isSelected'] as bool? ?? false,
    )
      ..id = json['id'] as String
      ..title = json['title'] as String
      ..downloadPath = json['downloadPath'] as String
      ..downloadedAudioLst = (json['downloadedAudioLst'] as List<dynamic>)
          .map((e) => AudioJson.fromJson(e as Map<String, dynamic>))
          .toList()
      ..playableAudioLst = (json['playableAudioLst'] as List<dynamic>)
          .map((e) => AudioJson.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$PlaylistJsonToJson(PlaylistJson instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'url': instance.url,
      'downloadPath': instance.downloadPath,
      'isSelected': instance.isSelected,
      'downloadedAudioLst': instance.downloadedAudioLst,
      'playableAudioLst': instance.playableAudioLst,
    };
