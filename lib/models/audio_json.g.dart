// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudioJson _$AudioJsonFromJson(Map<String, dynamic> json) => AudioJson(
      enclosingPlaylist: json['enclosingPlaylist'] == null
          ? null
          : PlaylistJson.fromJson(
              json['enclosingPlaylist'] as Map<String, dynamic>),
      originalVideoTitle: json['originalVideoTitle'] as String,
      videoUrl: json['videoUrl'] as String,
      audioDownloadDateTime:
          DateTime.parse(json['audioDownloadDateTime'] as String),
      audioDownloadDuration: json['audioDownloadDuration'] == null
          ? null
          : Duration(microseconds: json['audioDownloadDuration'] as int),
      videoUploadDate: DateTime.parse(json['videoUploadDate'] as String),
      audioDuration: json['audioDuration'] == null
          ? null
          : Duration(microseconds: json['audioDuration'] as int),
    )
      ..audioFileSize = json['audioFileSize'] as int
      ..audioDownloadSpeed = json['audioDownloadSpeed'] as int
      ..isPlaying = json['isPlaying'] as bool
      ..playSpeed = (json['playSpeed'] as num).toDouble()
      ..isMusicQuality = json['isMusicQuality'] as bool;

Map<String, dynamic> _$AudioJsonToJson(AudioJson instance) => <String, dynamic>{
      'enclosingPlaylist': instance.enclosingPlaylist,
      'originalVideoTitle': instance.originalVideoTitle,
      'videoUrl': instance.videoUrl,
      'audioDownloadDateTime': instance.audioDownloadDateTime.toIso8601String(),
      'audioDownloadDuration': instance.audioDownloadDuration?.inMicroseconds,
      'videoUploadDate': instance.videoUploadDate.toIso8601String(),
      'audioDuration': instance.audioDuration?.inMicroseconds,
      'audioFileSize': instance.audioFileSize,
      'audioDownloadSpeed': instance.audioDownloadSpeed,
      'isPlaying': instance.isPlaying,
      'playSpeed': instance.playSpeed,
      'isMusicQuality': instance.isMusicQuality,
    };
