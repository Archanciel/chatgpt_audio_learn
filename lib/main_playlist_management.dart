import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiKey = 'AIzaSyDhywmh5EKopsNsaszzMkLJ719aQa2NHBw';

Future<void> main() async {
  String playlistId = 'PLzwWSJNcZTMTB9iwbu77FGokc3WsoxuV0';
  String videoId = '4iRrusLxMIY';
  String videoIdLong = 'UEx6d1dTSk5jWlRNVEI5aXdidTc3Rkdva2MzV3NveHVWMC4zRjM0MkVCRTg0MkYyQTM0';
  

  // Obtain the date a video was added to a playlist
  DateTime addedDate = await getVideoAddedDate(playlistId, videoId);
  print('Video added on: $addedDate');

  // Remove the video from the playlist
  bool removed = await removeVideoFromPlaylist(playlistId, videoId);
  print(
      removed ? 'Video removed successfully.' : 'Failed to remove the video.');
}

Future<DateTime> getVideoAddedDate(String playlistId, String videoId) async {
  String playlistUrl =
      'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=$playlistId&key=$apiKey';
  String videoUrl =
      'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=$playlistId&videoId=$videoId&key=$apiKey';
  var response = await http.get(Uri.parse(videoUrl));
  var jsonResponse = jsonDecode(response.body);

  if (jsonResponse['items'].length > 0) {
    String publishedAt = jsonResponse['items'][0]['snippet']['publishedAt'];
    return DateTime.parse(publishedAt);
  } else {
    throw Exception('Video not found in the playlist.');
  }
}

Future<bool> removeVideoFromPlaylist(String playlistId, String videoId) async {
  String url =
      'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=$playlistId&videoId=$videoId&key=$apiKey';
  var response = await http.get(Uri.parse(url));
  var jsonResponse = jsonDecode(response.body);

  if (jsonResponse['items'].length > 0) {
    String playlistItemId = jsonResponse['items'][0]['id'];

    String deleteUrl =
        'https://www.googleapis.com/youtube/v3/playlistItems?id=$playlistItemId&key=$apiKey';
    var deleteResponse = await http.delete(Uri.parse(deleteUrl));

    return deleteResponse.statusCode == 204;
  } else {
    return false;
  }
}
