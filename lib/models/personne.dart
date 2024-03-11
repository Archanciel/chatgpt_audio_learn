import 'package:json_annotation/json_annotation.dart';
import 'adresse.dart';
import 'adresse.dart'; // Importez votre classe Adresse

part 'personne.g.dart';

@JsonSerializable()
class Personne {
  String nom;
  int age;
  List<Adresse> adresses; // Un champ qui est une liste d'objets Adresse

  Personne({required this.nom, required this.age, required this.adresses});

  // Factory pour la désérialisation
  factory Personne.fromJson(Map<String, dynamic> json) => _$PersonneFromJson(json);

  // Méthode pour la sérialisation
  Map<String, dynamic> toJson() => _$PersonneToJson(this);
}
