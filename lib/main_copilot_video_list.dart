import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

Future<void> main(List<String> args) async {
  const String playlistUrl =
      'https://youtube.com/playlist?list=PLzwWSJNcZTMRBJuvE6vk6PMnqIBhCKUIa';

  String playlistId = getYoutubePlaylistIdFromUrl(playlistUrl);
  List videos = await getListOfVideosReferencedInYoutubePlaylist(playlistId);
  List<Map<String, dynamic>> videoLst = getVideoDetailsFromListOfVideos(videos);

  // Flutter app to display the videoLst in a ListView
  runApp(MyApp(videoLst: videoLst));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.videoLst,
  });

  final List<Map<String, dynamic>> videoLst;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Youtube Playlist'),
        ),
        body: ListView.builder(
          itemCount: videoLst.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(videoLst[index]['title']),
              leading: Image.network(
                  videoLst[index]['snippet']['thumbnails']['default']['url']),
              onTap: () => _launchURL(videoLst[index]['videoId']),
            );
          },
        ),
      ),
    );
  }

  Future<void> _launchURL(String videoId) async {
    if (Platform.isAndroid) {
      String youtubeAppUrl = 'vnd.youtube://www.youtube.com/watch?v=$videoId';
      Uri uri = Uri.parse(youtubeAppUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $youtubeAppUrl';
      }
    } else {
      String url = 'https://www.youtube.com/watch?v=$videoId';
      Uri uri = Uri.parse(url);
      await launchUrl(uri);
    }
  }
}

String getYoutubePlaylistIdFromUrl(String url) {
  var playlistId = url.split('list=')[1];
  return playlistId;
}

Future<List<dynamic>> getListOfVideosReferencedInYoutubePlaylist(
    String playlistId) async {
  const String apiKey = 'AIzaSyDhywmh5EKopsNsaszzMkLJ719aQa2NHBw';

  var url =
      'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=$playlistId&key=$apiKey';

  Uri uri = Uri.parse(url);
  http.Response response = await http.get(uri);
  Map<String, dynamic> json = jsonDecode(response.body);
  List<dynamic> videos = json['items'];

  return videos;
}

List<Map<String, dynamic>> getVideoDetailsFromListOfVideos(
    List<dynamic> videos) {
  List<Map<String, dynamic>> videoDetails = [];

  for (Map<String, dynamic> video in videos) {
    Map<String, dynamic> snippet = video['snippet'];
    Map<String, dynamic> resourceId = snippet['resourceId'];
    String videoId = resourceId['videoId'];
    String title = snippet['title'];

    Map<String, dynamic> videoDetail = {};
    videoDetail['title'] = title;
    videoDetail['videoId'] = videoId;
    videoDetail['url'] = 'https://www.youtube.com/watch?v=$videoId';
    videoDetail['snippet'] = snippet;

    videoDetails.add(videoDetail);
  }

  return videoDetails;
}
