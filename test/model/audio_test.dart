import 'package:chatgpt_audio_learn/models/audio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Audio.replaceUnauthorizedDirOrFileNameChars', () {
    test('Test replace unauthorized characters', () {
      const String playlistTitle =
          "Audio: - ET L'UNIVERS DISPARAÎTRA/La \\nature * illusoire de notre réalité et le pouvoir transcendant du |véritable \"pardon\" + commentaires de <Gary> Renard ?";
      const String expectedFileName =
          "Audio - - ET L'UNIVERS DISPARAÎTRA_La nature   illusoire de notre réalité et le pouvoir transcendant du _véritable 'pardon' + commentaires de Gary Renard ";

      final String actualFileName =
          Audio.replaceUnauthorizedDirOrFileNameChars(playlistTitle);

      expect(actualFileName, expectedFileName);
    });

    test('Test replace OR char', () {
      const String playlistTitle =
          "💥 EFFONDREMENT Imminent de l'Euro ?! | 👉 Maintenant, La Fin de l'Euro Approche ?!";
      const String expectedFileName =
          "💥 EFFONDREMENT Imminent de l'Euro ! _ 👉 Maintenant, La Fin de l'Euro Approche !";

      final String actualFileName =
          Audio.replaceUnauthorizedDirOrFileNameChars(playlistTitle);

      expect(actualFileName, expectedFileName);
    });

    test('Test replace OR char at end of fileName', () {
      const String playlistTitle =
          'Indian 🇮🇳|American🇺🇸| Japanese🇯🇵|Students #youtubeshorts #shorts |Samayra Narula| Subscribe |';
      const String expectedFileName =
          'Indian 🇮🇳_American🇺🇸_ Japanese🇯🇵_Students #youtubeshorts #shorts _Samayra Narula_ Subscribe ';

      final String actualFileName =
          Audio.replaceUnauthorizedDirOrFileNameChars(playlistTitle);

      expect(actualFileName, expectedFileName);
    });

    test('Test replace double OR char', () {
      const String playlistTitle =
          'Lambda Expressions & Anonymous Functions ||  Python Tutorial  ||  Learn Python Programming';
      const String expectedFileName =
          'Lambda Expressions & Anonymous Functions _  Python Tutorial  _  Learn Python Programming';

      final String actualFileName =
          Audio.replaceUnauthorizedDirOrFileNameChars(playlistTitle);

      expect(actualFileName, expectedFileName);
    });

    test('Test replace double slash char', () {
      const String videoTitle =
          '9 Dart concepts to know before you jump into Flutter // for super beginners in Flutter';
      const String expectedFileName =
          '9 Dart concepts to know before you jump into Flutter _ for super beginners in Flutter';

      final String actualFileName =
          Audio.replaceUnauthorizedDirOrFileNameChars(videoTitle);

      expect(actualFileName, expectedFileName);
    });
  });
}
