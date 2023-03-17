import 'dart:convert';
import 'dart:io';

import 'package:chatgpt_audio_learn/utils/dir_util.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

// Define the IDs of the playlist and video to remove
const playlistId = 'PLzwWSJNcZTMTB9iwbu77FGokc3WsoxuV0';
const videoId = 'oxXpB9pSETo';

const apiKey = kGoogleApiKey;

class PlaylistEditVM extends ChangeNotifier {
// Authenticate with the YouTube Data API using a JSON file
  Future<AutoRefreshingAuthClient> authenticate() async {
    var path =
        '${await DirUtil.getPlaylistDownloadHomePath()}${Platform.pathSeparator}$kSecretClientCodeJsonFileName';
    var jsonDataStr = File(path).readAsStringSync();
    Map<String, dynamic> jsonData = jsonDecode(jsonDataStr);
    var serviceAccountCredentials =
        ServiceAccountCredentials.fromJson(jsonData);
    final credentials = serviceAccountCredentials;
    final scopes = [YouTubeApi.youtubeForceSslScope];
    return await clientViaServiceAccount(credentials, scopes);
  }

// Remove the video from the playlist
  // Future<void> removeVideoFromPlaylist() async {
  //   final client = await authenticate();
  //   final youtube = YouTubeApi(client);

  //   try {
  //     await youtube.playlistItems.delete(videoId).then((value) {
  //       print(
  //           'The video with ID "$videoId" has been removed from the playlist with ID "$playlistId".');
  //     });
  //   } catch (error) {
  //     print('An error occurred: $error');
  //   } finally {
  //     client.close();
  //   }
  // }

  /// not working
  Future<void> removeVideoFromPlaylist() async {
    const url =
        'https://www.googleapis.com/youtube/v3/playlistItems?part=id&playlistId=$playlistId&videoId=$videoId&key=$apiKey';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 204) {
      print(
          'The video with ID "$videoId" has been removed from the playlist with ID "$playlistId".');
    } else {
      print('An error occurred: ${response.reasonPhrase}');
    }
  }
}
