import 'package:chatgpt_audio_learn/models/audio.dart';
import 'package:chatgpt_audio_learn/models/playlist.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Testing Playlist sorting methods', () {
    test('sortDownloadedAudioLst on validVideoTitle ascending', () {
      Playlist playlist = Playlist(url: 'https://example.com/playlist1');

      addDownloadedAudios(playlist);

      playlist.sortDownloadedAudioLst(
        audioSortCriteriomn: AudioSortCriterion.validVideoTitle,
        isSortAscending: true,
      );

      expect(playlist.downloadedAudioLst[0].originalVideoTitle, 'A');
      expect(playlist.downloadedAudioLst[1].originalVideoTitle, 'B');
      expect(playlist.downloadedAudioLst[2].originalVideoTitle, 'C');
    });

    test('sortDownloadedAudioLst on validVideoTitle descending', () {
      Playlist playlist = Playlist(url: 'https://example.com/playlist1');

      addDownloadedAudios(playlist);

      playlist.sortDownloadedAudioLst(
        audioSortCriteriomn: AudioSortCriterion.validVideoTitle,
        isSortAscending: false,
      );

      expect(playlist.downloadedAudioLst[0].originalVideoTitle, 'C');
      expect(playlist.downloadedAudioLst[1].originalVideoTitle, 'B');
      expect(playlist.downloadedAudioLst[2].originalVideoTitle, 'A');
    });

    test('sortDownloadedAudioLst on audioDownloadDateTime ascending', () {
      Playlist playlist = Playlist(url: 'https://example.com/playlist1');

      addDownloadedAudios(playlist);

      playlist.sortDownloadedAudioLst(
        audioSortCriteriomn: AudioSortCriterion.audioDownloadDateTime,
        isSortAscending: true,
      );

      expect(playlist.downloadedAudioLst[0].originalVideoTitle, 'B');
      expect(playlist.downloadedAudioLst[1].originalVideoTitle, 'C');
      expect(playlist.downloadedAudioLst[2].originalVideoTitle, 'A');
    });

    test('sortDownloadedAudioLst on audioDownloadDateTime descending', () {
      Playlist playlist = Playlist(url: 'https://example.com/playlist1');

      addDownloadedAudios(playlist);

      playlist.sortDownloadedAudioLst(
        audioSortCriteriomn: AudioSortCriterion.audioDownloadDateTime,
        isSortAscending: false,
      );

      expect(playlist.downloadedAudioLst[0].originalVideoTitle, 'A');
      expect(playlist.downloadedAudioLst[1].originalVideoTitle, 'C');
      expect(playlist.downloadedAudioLst[2].originalVideoTitle, 'B');
    });

    test('sortPlayableAudioLst on validVideoTitle ascending', () {
      Playlist playlist = Playlist(url: 'https://example.com/playlist2');

      addPlayableAudios(playlist);

      playlist.sortPlayableAudioLst(
        audioSortCriteriomn: AudioSortCriterion.validVideoTitle,
        isSortAscending: true,
      );

      expect(playlist.playableAudioLst[0].originalVideoTitle, 'A');
      expect(playlist.playableAudioLst[1].originalVideoTitle, 'B');
      expect(playlist.playableAudioLst[2].originalVideoTitle, 'C');
    });

    test('sortPlayableAudioLst on validVideoTitle descending', () {
      Playlist playlist = Playlist(url: 'https://example.com/playlist2');

      addPlayableAudios(playlist);

      playlist.sortPlayableAudioLst(
        audioSortCriteriomn: AudioSortCriterion.validVideoTitle,
        isSortAscending: false,
      );

      expect(playlist.playableAudioLst[0].originalVideoTitle, 'C');
      expect(playlist.playableAudioLst[1].originalVideoTitle, 'B');
      expect(playlist.playableAudioLst[2].originalVideoTitle, 'A');
    });

    test('sortPlayableAudioLst on audioDownloadDateTime ascending', () {
      Playlist playlist = Playlist(url: 'https://example.com/playlist2');

      addPlayableAudios(playlist);

      playlist.sortPlayableAudioLst(
        audioSortCriteriomn: AudioSortCriterion.audioDownloadDateTime,
        isSortAscending: true,
      );

      expect(playlist.playableAudioLst[0].originalVideoTitle, 'B');
      expect(playlist.playableAudioLst[1].originalVideoTitle, 'C');
      expect(playlist.playableAudioLst[2].originalVideoTitle, 'A');
    });

    test('sortPlayableAudioLst on audioDownloadDateTime descending', () {
      Playlist playlist = Playlist(url: 'https://example.com/playlist2');

      addPlayableAudios(playlist);

      playlist.sortPlayableAudioLst(
        audioSortCriteriomn: AudioSortCriterion.audioDownloadDateTime,
        isSortAscending: false,
      );

      expect(playlist.playableAudioLst[0].originalVideoTitle, 'A');
      expect(playlist.playableAudioLst[1].originalVideoTitle, 'C');
      expect(playlist.playableAudioLst[2].originalVideoTitle, 'B');
    });
  });
}

void addPlayableAudios(Playlist playlist) {
  playlist.insertAtStartPlayableAudio(Audio(
      enclosingPlaylist: playlist,
      originalVideoTitle: 'C',
      videoUrl: 'https://example.com/video1',
      audioDownloadDateTime: DateTime(2023, 3, 17),
      videoUploadDate: DateTime.now()));
  playlist.insertAtStartPlayableAudio(Audio(
      enclosingPlaylist: playlist,
      originalVideoTitle: 'A',
      videoUrl: 'https://example.com/video2',
      audioDownloadDateTime: DateTime(2023, 3, 20),
      videoUploadDate: DateTime.now()));
  playlist.insertAtStartPlayableAudio(Audio(
      enclosingPlaylist: playlist,
      originalVideoTitle: 'B',
      videoUrl: 'https://example.com/video3',
      audioDownloadDateTime: DateTime(2023, 3, 14),
      videoUploadDate: DateTime.now()));
}

void addDownloadedAudios(Playlist playlist) {
  playlist.addDownloadedAudio(Audio(
      enclosingPlaylist: playlist,
      originalVideoTitle: 'C',
      videoUrl: 'https://example.com/video1',
      audioDownloadDateTime: DateTime(2023, 3, 20),
      videoUploadDate: DateTime.now()));
  playlist.addDownloadedAudio(Audio(
      enclosingPlaylist: playlist,
      originalVideoTitle: 'A',
      videoUrl: 'https://example.com/video2',
      audioDownloadDateTime: DateTime(2023, 3, 25),
      videoUploadDate: DateTime.now()));
  playlist.addDownloadedAudio(Audio(
      enclosingPlaylist: playlist,
      originalVideoTitle: 'B',
      videoUrl: 'https://example.com/video3',
      audioDownloadDateTime: DateTime(2023, 3, 18),
      videoUploadDate: DateTime.now()));
}
