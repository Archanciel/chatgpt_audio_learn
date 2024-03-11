// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personne.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Personne _$PersonneFromJson(Map<String, dynamic> json) => Personne(
      nom: json['nom'] as String,
      age: json['age'] as int,
      adresses: (json['adresses'] as List<dynamic>)
          .map((e) => Adresse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PersonneToJson(Personne instance) => <String, dynamic>{
      'nom': instance.nom,
      'age': instance.age,
      'adresses': instance.adresses,
    };
