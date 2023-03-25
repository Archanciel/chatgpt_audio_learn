import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:chatgpt_audio_learn/models/audio.dart';
import 'package:chatgpt_audio_learn/models/playlist.dart';
import 'package:chatgpt_audio_learn/services/json_data_service.dart';
import 'package:flutter_test/flutter_test.dart';

class UnsupportedClass {}

class MyUnsupportedTestClass {
  final String name;
  final int value;

  MyUnsupportedTestClass({required this.name, required this.value});

  factory MyUnsupportedTestClass.fromJson(Map<String, dynamic> json) {
    return MyUnsupportedTestClass(
      name: json['name'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }
}

void main() {
  const jsonPath = 'test.json';

  group('JsonDataService individual', () {
    test('saveToFile and loadFromFile for one Audio instance', () async {
      // Create a temporary directory to store the serialized Audio object
      Directory tempDir = await Directory.systemTemp.createTemp('AudioTest');
      String filePath = path.join(tempDir.path, 'audio.json');

      // Create an Audio instance
      Audio originalAudio = Audio(
        enclosingPlaylist: null,
        originalVideoTitle: 'Test Video Title',
        videoUrl: 'https://www.youtube.com/watch?v=testVideoID',
        audioDownloadDate: DateTime(2023, 3, 24),
        videoUploadDate: DateTime(2023, 3, 1),
        audioDuration: Duration(minutes: 5, seconds: 30),
      );

      // Save the Audio instance to a file
      JsonDataService.saveToFile(model: originalAudio, path: filePath);

      // Load the Audio instance from the file
      Audio deserializedAudio =
          JsonDataService.loadFromFile(path: filePath, type: Audio);

      // Compare the deserialized Audio instance with the original Audio instance
      compareDeserializedWithOriginalAudio(deserializedAudio, originalAudio);

      // Cleanup the temporary directory
      await tempDir.delete(recursive: true);
    });
    test(
        'saveToFile and loadFromFile for one Audio instance with null audioDuration',
        () async {
      // Create a temporary directory to store the serialized Audio object
      Directory tempDir = await Directory.systemTemp.createTemp('AudioTest');
      String filePath = path.join(tempDir.path, 'audio.json');

      // Create an Audio instance
      Audio originalAudio = Audio(
        enclosingPlaylist: null,
        originalVideoTitle: 'Test Video Title',
        videoUrl: 'https://www.youtube.com/watch?v=testVideoID',
        audioDownloadDate: DateTime(2023, 3, 24),
        videoUploadDate: DateTime(2023, 3, 1),
      );

      // Save the Audio instance to a file
      JsonDataService.saveToFile(model: originalAudio, path: filePath);

      // Load the Audio instance from the file
      Audio deserializedAudio =
          JsonDataService.loadFromFile(path: filePath, type: Audio);

      // Compare the deserialized Audio instance with the original Audio instance
      compareDeserializedWithOriginalAudio(deserializedAudio, originalAudio);

      // Cleanup the temporary directory
      await tempDir.delete(recursive: true);
    });
    test('saveToFile and loadFromFile for one Playlist instance', () async {
      // Create a temporary directory to store the serialized Audio object
      Directory tempDir = await Directory.systemTemp.createTemp('AudioTest');
      String filePath = path.join(tempDir.path, 'audio.json');
      // Create a Playlist with 2 Audio instances
      Playlist testPlaylist = Playlist(
        url: 'https://www.example.com/playlist-url',
      );

      testPlaylist.title = 'Test Playlist';
      testPlaylist.downloadPath = 'path/to/downloads';

      Audio audio1 = Audio(
        enclosingPlaylist: testPlaylist,
        originalVideoTitle: 'Test Video 1',
        videoUrl: 'https://www.example.com/video-url-1',
        audioDownloadDate: DateTime.now(),
        videoUploadDate: DateTime.now().subtract(Duration(days: 10)),
      );

      Audio audio2 = Audio(
        enclosingPlaylist: testPlaylist,
        originalVideoTitle: 'Test Video 2',
        videoUrl: 'https://www.example.com/video-url-2',
        audioDownloadDate: DateTime.now(),
        videoUploadDate: DateTime.now().subtract(Duration(days: 5)),
        audioDuration: Duration(minutes: 5, seconds: 30),
      );

      testPlaylist.addDownloadedAudio(audio1);
      testPlaylist.addDownloadedAudio(audio2);

      // Save Playlist to a file
      JsonDataService.saveToFile(model: testPlaylist, path: filePath);

      // Load Playlist from the file
      Playlist loadedPlaylist =
          JsonDataService.loadFromFile(path: filePath, type: Playlist);

      // Compare original and loaded Playlist
      compareDeserializedWithOriginalPlaylist(loadedPlaylist, testPlaylist);

      // Cleanup the temporary directory
      await tempDir.delete(recursive: true);
    });
    test('ClassNotContainedInJsonFileException', () {
      // Prepare a temporary file
      File tempFile = File('temp.json');
      tempFile.writeAsStringSync(jsonEncode({'test': 'data'}));

      try {
        // Try to load a MyClass instance from the temporary file, which should throw an exception
        JsonDataService.loadFromFile(path: 'temp.json', type: Audio);
      } catch (e) {
        expect(e, isA<ClassNotContainedInJsonFileException>());
      } finally {
        tempFile.deleteSync(); // Clean up the temporary file
      }
    });
    test('ClassNotSupportedByToJsonDataServiceException', () {
      // Create a class not supported by JsonDataService

      try {
        // Try to encode an instance of UnsupportedClass, which should throw an exception
        JsonDataService.encodeJson(UnsupportedClass());
      } catch (e) {
        expect(e, isA<ClassNotSupportedByToJsonDataServiceException>());
      }
    });
  });
  group('JsonDataService list', () {
    test('saveListToFile() ClassNotSupportedByToJsonDataServiceException',
        () async {
      // Prepare test data
      List<MyUnsupportedTestClass> testList = [
        MyUnsupportedTestClass(name: 'Test1', value: 1),
        MyUnsupportedTestClass(name: 'Test2', value: 2),
      ];

      // Save the list to a file
      try {
        // Try to decode the JSON string into an instance of UnsupportedClass, which should throw an exception
        JsonDataService.saveListToFile(path: jsonPath, data: testList);
      } catch (e) {
        expect(e, isA<ClassNotSupportedByToJsonDataServiceException>());
      }
    });
    test('saveListToFile() ClassNotSupportedByFromJsonDataServiceException',
        () async {
      // Create an Audio instance
      Audio originalAudio = Audio(
        enclosingPlaylist: null,
        originalVideoTitle: 'Test Video Title',
        videoUrl: 'https://www.youtube.com/watch?v=testVideoID',
        audioDownloadDate: DateTime(2023, 3, 24),
        videoUploadDate: DateTime(2023, 3, 1),
        audioDuration: Duration(minutes: 5, seconds: 30),
      );

      // Save the Audio instance to a file
      JsonDataService.saveToFile(model: originalAudio, path: jsonPath);

      // Load the list from the file
      try {
        List<MyUnsupportedTestClass> loadedList =
            JsonDataService.loadListFromFile(
                path: jsonPath, type: MyUnsupportedTestClass);
      } catch (e) {
        expect(e, isA<ClassNotSupportedByFromJsonDataServiceException>());
      }

      // Clean up the test file
      File(jsonPath).deleteSync();
    });
    test('saveListToFile() and loadListFromFile() for Audio list', () async {
      // Create an Audio instance
      Audio audioOne = Audio(
        enclosingPlaylist: null,
        originalVideoTitle: 'Test Video One Title',
        videoUrl: 'https://www.youtube.com/watch?v=testVideoID',
        audioDownloadDate: DateTime(2023, 3, 24),
        videoUploadDate: DateTime(2023, 3, 1),
        audioDuration: Duration(minutes: 5, seconds: 30),
      );

      Audio audioTwo = Audio(
        enclosingPlaylist: null,
        originalVideoTitle: 'Test Video Two Title',
        videoUrl: 'https://www.youtube.com/watch?v=testVideoID',
        audioDownloadDate: DateTime(2023, 3, 24),
        videoUploadDate: DateTime(2023, 3, 1),
        audioDuration: Duration(minutes: 5, seconds: 30),
      );

      // Prepare test data
      List<Audio> testList = [audioOne, audioTwo];

      // Save the list to a file
      JsonDataService.saveListToFile(data: testList, path: jsonPath);

      // Load the list from the file
      List<Audio> loadedList =
          await JsonDataService.loadListFromFile(path: jsonPath, type: Audio);

      // Check if the loaded list matches the original list
      expect(loadedList.length, testList.length);

      for (int i = 0; i < loadedList.length; i++) {
        compareDeserializedWithOriginalAudio(loadedList[i], testList[i]);
      }

      // Clean up the test file
      File(jsonPath).deleteSync();
    });
    test('saveListToFile() and loadListFromFile() for Playlist list', () async {
      // Create an Audio instance
      Playlist testPlaylistOne = Playlist(
        url: 'https://www.example.com/playlist-url',
      );

      testPlaylistOne.title = 'Test Playlist One';
      testPlaylistOne.downloadPath = 'path/to/downloads';

      Audio audio1 = Audio(
        enclosingPlaylist: testPlaylistOne,
        originalVideoTitle: 'Test Video 1',
        videoUrl: 'https://www.example.com/video-url-1',
        audioDownloadDate: DateTime.now(),
        videoUploadDate: DateTime.now().subtract(Duration(days: 10)),
      );

      Audio audio2 = Audio(
        enclosingPlaylist: testPlaylistOne,
        originalVideoTitle: 'Test Video 2',
        videoUrl: 'https://www.example.com/video-url-2',
        audioDownloadDate: DateTime.now(),
        videoUploadDate: DateTime.now().subtract(Duration(days: 5)),
        audioDuration: Duration(minutes: 5, seconds: 30),
      );

      testPlaylistOne.addDownloadedAudio(audio1);
      testPlaylistOne.addDownloadedAudio(audio2);

      Playlist testPlaylistTwo = Playlist(
        url: 'https://www.example.com/playlist-url',
      );

      testPlaylistTwo.title = 'Test Playlist Two';
      testPlaylistTwo.downloadPath = 'path/to/downloads';

      testPlaylistTwo.addDownloadedAudio(audio1);
      testPlaylistTwo.addDownloadedAudio(audio2);

      // Prepare test data
      List<Playlist> testList = [testPlaylistOne, testPlaylistTwo];

      // Save the list to a file
      JsonDataService.saveListToFile(data: testList, path: jsonPath);

      // Load the list from the file
      List<Playlist> loadedList = await JsonDataService.loadListFromFile(
          path: jsonPath, type: Playlist);

      // Check if the loaded list matches the original list
      expect(loadedList.length, testList.length);

      for (int i = 0; i < loadedList.length; i++) {
        compareDeserializedWithOriginalPlaylist(loadedList[i], testList[i]);
      }

      // Clean up the test file
      File(jsonPath).deleteSync();
    });
  });
}

void compareDeserializedWithOriginalPlaylist(
    Playlist loadedPlaylist, Playlist testPlaylist) {
  expect(loadedPlaylist.title, testPlaylist.title);
  expect(loadedPlaylist.downloadPath, testPlaylist.downloadPath);
  expect(loadedPlaylist.url, testPlaylist.url);

  // Compare Audio instances in original and loaded Playlist
  expect(loadedPlaylist.downloadedAudioLst.length, 2);

  for (int i = 0; i < loadedPlaylist.downloadedAudioLst.length; i++) {
    Audio originalAudio = testPlaylist.downloadedAudioLst[i];
    Audio loadedAudio = loadedPlaylist.downloadedAudioLst[i];

    compareDeserializedWithOriginalAudio(loadedAudio, originalAudio);
  }
}

void compareDeserializedWithOriginalAudio(
  Audio deserializedAudio,
  Audio originalAudio,
) {
  expect(
      deserializedAudio.originalVideoTitle, originalAudio.originalVideoTitle);
  expect(deserializedAudio.validVideoTitle, originalAudio.validVideoTitle);
  expect(deserializedAudio.videoUrl, originalAudio.videoUrl);
  expect(deserializedAudio.audioDownloadDate.toIso8601String(),
      originalAudio.audioDownloadDate.toIso8601String());
  expect(deserializedAudio.videoUploadDate.toIso8601String(),
      originalAudio.videoUploadDate.toIso8601String());
  expect(deserializedAudio.audioDuration,
      originalAudio.audioDuration ?? const Duration(milliseconds: 0));
  expect(deserializedAudio.fileName, originalAudio.fileName);
}
