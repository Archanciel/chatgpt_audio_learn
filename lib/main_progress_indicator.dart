import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: MaterialApp(
        title: 'YouTube Audio Downloader',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class VideoInfo {
  final String title;
  final String duration;
  final String fileSize;

  VideoInfo(
      {required this.title, required this.duration, required this.fileSize});
}

class HomeViewModel extends ChangeNotifier {
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  VideoInfo? _videoInfo;

  bool get isDownloading => _isDownloading;
  double get downloadProgress => _downloadProgress;
  VideoInfo? get videoInfo => _videoInfo;

  void _updateDownloadProgress(double progress) {
    _downloadProgress = progress;
    notifyListeners();
  }

  Future<void> downloadAudio(String url) async {
    _isDownloading = true;
    notifyListeners();

    YoutubeExplode youtubeExplode = YoutubeExplode();
    Video video = await youtubeExplode.videos.get(url);
    StreamManifest streamManifest = await youtubeExplode.videos.streamsClient.getManifest(url);
    AudioOnlyStreamInfo audioStreamInfo = streamManifest.audioOnly.first;
    Stream<List<int>> audioStream = youtubeExplode.videos.streamsClient.get(audioStreamInfo);

    String title = video.title;
    String durationStr = video.duration.toString();
    int audioFileSize = audioStreamInfo.size.totalBytes;

    _videoInfo = VideoInfo(
        title: title, duration: durationStr, fileSize: audioFileSize.toString());

    Directory directory = await getApplicationDocumentsDirectory();
    String audioFilePathName = '${directory.path}/$title.mp3';

    File file = File(audioFilePathName);
    IOSink audioFileSink = file.openWrite();
    int totalBytesRead = 0;

    // Créez un Timer pour limiter les appels à notifyListeners
    Duration updateInterval = const Duration(seconds: 1);
    DateTime lastUpdate = DateTime.now();
    Timer timer = Timer.periodic(updateInterval, (timer) {
      if (DateTime.now().difference(lastUpdate) >= updateInterval) {
        _updateDownloadProgress(totalBytesRead / audioFileSize);
        lastUpdate = DateTime.now();
      }
    });

    await for (var byteChunk in audioStream) {
      totalBytesRead += byteChunk.length;

      // Vérifiez si le délai a été dépassé avant de mettre à jour la progression
      if (DateTime.now().difference(lastUpdate) >= updateInterval) {
        _updateDownloadProgress(totalBytesRead / audioFileSize);
        lastUpdate = DateTime.now();
      }
      audioFileSink.add(byteChunk);
    }

    // Assurez-vous de mettre à jour la progression une dernière fois à 100% avant de terminer
    _updateDownloadProgress(1.0);

    // Annulez le Timer pour éviter les appels inutiles
    timer.cancel();

    await audioFileSink.flush();
    await audioFileSink.close();

    youtubeExplode.close();

    _isDownloading = false;
    notifyListeners();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YouTube Audio Downloader')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: 'YouTube Video URL',
                  hintText: 'https://youtu.be/M0WItGrxnBU',
                ),
              ),
              const SizedBox(height: 16.0),
              Consumer<HomeViewModel>(
                builder: (context, viewModel, child) {
                  return ElevatedButton(
                    onPressed: viewModel.isDownloading
                        ? null
                        : () => viewModel.downloadAudio(
                            'https://youtu.be/M0WItGrxnBU'), // Remplacer 'YouTube Video URL' par la valeur du TextField
                    child: const Text('Download'),
                  );
                },
              ),
              const SizedBox(height: 16.0),
              Consumer<HomeViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isDownloading) {
                    return Column(
                      children: [
                        const CircularProgressIndicator(),
                        Text(
                            '${(viewModel.downloadProgress * 100).toStringAsFixed(1)}%'),
                        const SizedBox(height: 16.0),
                        LinearProgressIndicator(
                            value: viewModel.downloadProgress),
                        const SizedBox(height: 16.0),
                        Text(
                            'Progress: ${(viewModel.downloadProgress * 100).toStringAsFixed(1)}%'),
                      ],
                    );
                  } else if (viewModel.videoInfo != null) {
                    return Column(
                      children: [
                        Text('Title: ${viewModel.videoInfo!.title}'),
                        Text('Duration: ${viewModel.videoInfo!.duration}'),
                        Text(
                            'File size: ${viewModel.videoInfo!.fileSize}'), // Mettre à jour la taille du fichier dans le ViewModel lors du téléchargement
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
