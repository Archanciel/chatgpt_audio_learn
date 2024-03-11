import 'package:json_annotation/json_annotation.dart';

part 'votre_classe.g.dart';

@JsonSerializable()
class VotreClasse {
  final String propriete1;
  final int propriete2;

  VotreClasse({required this.propriete1, required this.propriete2});

  // Factory pour la désérialisation
  factory VotreClasse.fromJson(Map<String, dynamic> json) => _$VotreClasseFromJson(json);

  // Méthode pour la sérialisation
  Map<String, dynamic> toJson() => _$VotreClasseToJson(this);
}
