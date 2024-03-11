// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adresse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Adresse _$AdresseFromJson(Map<String, dynamic> json) => Adresse(
      rue: json['rue'] as String,
      ville: json['ville'] as String,
      codePostal: json['codePostal'] as int,
    );

Map<String, dynamic> _$AdresseToJson(Adresse instance) => <String, dynamic>{
      'rue': instance.rue,
      'ville': instance.ville,
      'codePostal': instance.codePostal,
    };
