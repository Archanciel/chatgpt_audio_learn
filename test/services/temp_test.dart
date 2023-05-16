
import 'package:flutter_test/flutter_test.dart';
import 'package:chatgpt_audio_learn/models/audio.dart';

enum SortingOption {
  validAudioTitle,
}

void main() {
  group('sortAudioLstBySortingOption', () {
    test('sort by title starting with non language chars', () {
      Audio title = Audio.fullConstructor(
        enclosingPlaylist: null,
        originalVideoTitle: "'title",
        validVideoTitle: "'title",
        videoUrl: 'videoUrl',
        audioDownloadDateTime: DateTime.now(),
        audioDownloadDuration: Duration(seconds: 1),
        audioDownloadSpeed: 1,
        videoUploadDate: DateTime.now(),
        audioDuration: Duration(seconds: 1),
        isMusicQuality: true,
        audioFileName: 'audioFileName',
        audioFileSize: 1,
      );

      Audio avec_percent_title = Audio.fullConstructor(
        enclosingPlaylist: null,
        originalVideoTitle: "avec title",
        validVideoTitle: "avec title",
        videoUrl: 'videoUrl',
        audioDownloadDateTime: DateTime.now(),
        audioDownloadDuration: Duration(seconds: 1),
        audioDownloadSpeed: 1,
        videoUploadDate: DateTime.now(),
        audioDuration: Duration(seconds: 1),
        isMusicQuality: true,
        audioFileName: 'audioFileName',
        audioFileSize: 1,
      );

      Audio epicure = Audio.fullConstructor(
        enclosingPlaylist: null,
        originalVideoTitle: "ÉPICURE - La mort n'est rien 📏",
        validVideoTitle: "ÉPICURE - La mort n'est rien",
        videoUrl: 'videoUrl',
        audioDownloadDateTime: DateTime.now(),
        audioDownloadDuration: Duration(seconds: 1),
        audioDownloadSpeed: 1,
        videoUploadDate: DateTime.now(),
        audioDuration: Duration(seconds: 1),
        isMusicQuality: true,
        audioFileName: 'audioFileName',
        audioFileSize: 1,
      );

      Audio echapper = Audio.fullConstructor(
        enclosingPlaylist: null,
        originalVideoTitle: "Échapper à l'illusion de l'esprit",
        validVideoTitle: "Échapper à l'illusion de l'esprit",
        videoUrl: 'videoUrl',
        audioDownloadDateTime: DateTime.now(),
        audioDownloadDuration: Duration(seconds: 1),
        audioDownloadSpeed: 1,
        videoUploadDate: DateTime.now(),
        audioDuration: Duration(seconds: 1),
        isMusicQuality: true,
        audioFileName: 'audioFileName',
        audioFileSize: 1,
      );

      Audio a_lire_title = Audio.fullConstructor(
        enclosingPlaylist: null,
        originalVideoTitle: "à lire title",
        validVideoTitle: "à lire title",
        videoUrl: 'videoUrl',
        audioDownloadDateTime: DateTime.now(),
        audioDownloadDuration: Duration(seconds: 1),
        audioDownloadSpeed: 1,
        videoUploadDate: DateTime.now(),
        audioDuration: Duration(seconds: 1),
        isMusicQuality: false,
        audioFileName: 'audioFileName',
        audioFileSize: 1,
      );

      Audio nine_title = Audio.fullConstructor(
        enclosingPlaylist: null,
        originalVideoTitle: "9 title",
        validVideoTitle: "9 title",
        videoUrl: 'videoUrl',
        audioDownloadDateTime: DateTime.now(),
        audioDownloadDuration: Duration(seconds: 1),
        audioDownloadSpeed: 1,
        videoUploadDate: DateTime.now(),
        isMusicQuality: false,
        audioDuration: Duration(seconds: 1),
        audioFileName: 'audioFileName',
        audioFileSize: 1,
      );

      List<Audio?> audioLst = [
        title,
        avec_percent_title,
        epicure,
        echapper,
        a_lire_title,
        nine_title,
      ];

      List<Audio?> expectedResultForTitleAsc = [
        nine_title,
        epicure,
        echapper,
        avec_percent_title,
        a_lire_title,
        title,
      ];

      List<Audio?> expectedResultForTitleDesc = [
        title,
        a_lire_title,
        avec_percent_title,
        echapper,
        epicure,
        nine_title,
      ];

      List<Audio> sortedByTitleAsc = sortAudioLstBySortingOption(
        audioLst: List<Audio>.from(audioLst), // copy list
        sortingOption: SortingOption.validAudioTitle,
        asc: true,
      );

      expect(
          sortedByTitleAsc.map((audio) => audio.validVideoTitle).toList(),
          equals(expectedResultForTitleAsc
              .map((audio) => audio!.validVideoTitle)
              .toList()));
    });
  });
}

List<Audio> sortAudioLstBySortingOption({
  required List<Audio> audioLst,
  required SortingOption sortingOption,
  bool asc = true,
}) {
  switch (sortingOption) {
    case SortingOption.validAudioTitle:
      return sortAudioLstByTitle(
        audioLst: audioLst,
        asc: asc,
      );
    default:
      return audioLst;
  }
}

// List<Audio> sortAudioLstByTitle({
//   required List<Audio> audioLst,
//   bool asc = true,
// }) {
//   if (asc) {
//     audioLst.sort((a, b) {
//       String cleanA = a.validVideoTitle
//           .trimLeft()
//           .replaceAll(RegExp(r'[^A-Za-z0-9éèêëîïôœùûüÿç]'), '');
//       String cleanB = b.validVideoTitle
//           .trimLeft()
//           .replaceAll(RegExp(r'[^A-Za-z0-9éèêëîïôœùûüÿç]'), '');
//       return cleanA.toLowerCase().compareTo(cleanB.toLowerCase());
//     });
//   } else {
//     audioLst.sort((a, b) {
//       String cleanA = a.validVideoTitle
//           .trimLeft()
//           .replaceAll(RegExp(r'[^A-Za-z0-9éèêëîïôœùûüÿç]'), '');
//       String cleanB = b.validVideoTitle
//           .trimLeft()
//           .replaceAll(RegExp(r'[^A-Za-z0-9éèêëîïôœùûüÿç]'), '');
//       return cleanB.toLowerCase().compareTo(cleanA.toLowerCase());
//     });
//   }
//   return audioLst;
// }

List<Audio> sortAudioLstByTitle({
  required List<Audio> audioLst,
  bool asc = true,
}) {
  final collator = Collator('fr', strength: Collator.SECONDARY); // Use 'fr' for French
  
  if (asc) {
    audioLst.sort((a, b) {
      String cleanA = a.validVideoTitle.trimLeft().replaceAll(RegExp(r'[^A-Za-z0-9éèêëîïôœùûüÿç]'), '');
      String cleanB = b.validVideoTitle.trimLeft().replaceAll(RegExp(r'[^A-Za-z0-9éèêëîïôœùûüÿç]'), '');
      return collator.compare(cleanA.toLowerCase(), cleanB.toLowerCase());
    });
  } else {
    audioLst.sort((a, b) {
      String cleanA = a.validVideoTitle.trimLeft().replaceAll(RegExp(r'[^A-Za-z0-9éèêëîïôœùûüÿç]'), '');
      String cleanB = b.validVideoTitle.trimLeft().replaceAll(RegExp(r'[^A-Za-z0-9éèêëîïôœùûüÿç]'), '');
      return collator.compare(cleanB.toLowerCase(), cleanA.toLowerCase());
    });
  }
  return audioLst;
}

  // List<Audio> sortAudioLstByTitle({
  //   required List<Audio> audioLst,
  //   bool asc = true,
  // }) {
  //   if (asc) {
  //     audioLst.sort((a, b) {
  //       String cleanA = a.validVideoTitle
  //           .replaceAll(RegExp(r'[^A-Za-z0-9éèêëîïôœùûüÿç]'), '');
  //       String cleanB = b.validVideoTitle
  //           .replaceAll(RegExp(r'[^A-Za-z0-9éèêëîïôœùûüÿç]'), '');
  //       return removeDiacritics(cleanA).compareTo(removeDiacritics(cleanB));
  //     });
  //   } else {
  //     audioLst.sort((a, b) {
  //       String cleanA = a.validVideoTitle
  //           .replaceAll(RegExp(r'[^A-Za-z0-9éèêëîïôœùûüÿç]'), '');
  //       String cleanB = b.validVideoTitle
  //           .replaceAll(RegExp(r'[^A-Za-z0-9éèêëîïôœùûüÿç]'), '');
  //       return removeDiacritics(cleanB).compareTo(removeDiacritics(cleanA));
  //     });
  //   }
  // 
  //   return audioLst;
  // }
/*
Expected: [
            '9 title',
            'ÉPICURE - La mort n\'est rien',
            'Échapper à l\'illusion de l\'esprit',
            'avec title',
            'à lire title',
            '\'title'
          ]
  Actual: [
            '9 title',
            'avec title',
            'Échapper à l\'illusion de l\'esprit',
            'à lire title',
            'ÉPICURE - La mort n\'est rien',
            '\'title'
          ]
*/