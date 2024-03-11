// Sérialisation Dart vers JSON: https://chat.openai.com/share/f1f69afe-58cb-4ef4-9dde-4f38b5912151

import 'dart:convert';

import 'models/audio_json.dart';
import 'models/playlist_json.dart';
import 'models/personne.dart';
import 'models/adresse.dart';

void main() {
  Adresse adresse1 = Adresse(
    rue: 'rue1',
    ville: 'ville1',
    codePostal: 1111,
  );
  Adresse adresse2 = Adresse(
    rue: 'rue2',
    ville: 'ville2',
    codePostal: 2222,
  );

  Personne personne1 = Personne(
    nom: 'personne1',
    age: 32,
    adresses: [
      adresse1,
      adresse2,
    ],
  );

  print('\nPersonneJson.toJson() :');
  print(jsonEncode(personne1.toJson()));

  PlaylistJson playlistJson = PlaylistJson(
    url: "https://url",
    isSelected: false,
  );

  AudioJson audio1 = AudioJson(
    enclosingPlaylist: playlistJson,
    originalVideoTitle: "originalVideoTitleAudio1",
    videoUrl: "videoUrlAudio1",
    audioDownloadDateTime: DateTime.now(),
    audioDownloadDuration: const Duration(
        seconds: 42), // Add 'const' keyword to improve performance.
    videoUploadDate: DateTime.now(),
    audioDuration: const Duration(
        seconds: 3600), // Add 'const' keyword to improve performance.
  );

  AudioJson audio2 = AudioJson(
    enclosingPlaylist: playlistJson,
    originalVideoTitle: "originalVideoTitleAudio2",
    videoUrl: "videoUrlAudio2",
    audioDownloadDateTime: DateTime.now(),
    audioDownloadDuration: const Duration(
        seconds: 84), // Add 'const' keyword to improve performance.
    videoUploadDate: DateTime.now(),
    audioDuration: const Duration(
        seconds: 7200), // Add 'const' keyword to improve performance.
  );

  playlistJson.addDownloadedAudio(audio1);
  playlistJson.addDownloadedAudio(audio2);

  print('\nPlaylistJson.toJson() :');
  print(jsonEncode(playlistJson.toJson()));
}
