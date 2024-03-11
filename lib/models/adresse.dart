import 'package:json_annotation/json_annotation.dart';

part 'adresse.g.dart';

@JsonSerializable()
class Adresse {
  String rue;
  String ville;
  int codePostal;

  Adresse({required this.rue, required this.ville, required this.codePostal});

  // Factory pour la désérialisation
  factory Adresse.fromJson(Map<String, dynamic> json) => _$AdresseFromJson(json);

  // Méthode pour la sérialisation
  Map<String, dynamic> toJson() => _$AdresseToJson(this);
}
