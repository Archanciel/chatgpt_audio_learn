import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:window_manager/window_manager.dart';

import 'package:audioplayers/audioplayers.dart';

const bool kAudioFileNamePrefixIncludeTime = true;
const double kAudioDefaultSpeed = 1.0;

enum AudioSortCriterion { audioDownloadDateTime, validVideoTitle }

enum PlaylistType { youtube, local }

enum PlaylistQuality { music, voice }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(500, 715),
    // center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    // keeping Windows title bar enables to move the app window
    // titleBarStyle: TitleBarStyle.hidden,
    // windowButtonVisibility: false,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(MaterialApp(
    home: AudioPlayerView(),
  ));
}

class Playlist {
  String id = '';
  String title = '';
  String url;
  PlaylistType playlistType;
  PlaylistQuality playlistQuality;
  String downloadPath = '';
  bool isSelected;

  // Contains the audios once referenced in the Youtube playlist
  // which were downloaded.
  List<Audio> downloadedAudioLst = [];

  // Contains the downloaded audios currently available on the
  // device.
  List<Audio> playableAudioLst = [];

  // If a playable audio is or has been playing, this variable
  // contains the index of the audio in the playableAudioLst.
  int currentPlayableAudioIndex = -1;

  Playlist({
    this.url = '',
    this.id = '',
    this.title = '',
    required this.playlistType,
    required this.playlistQuality,
    this.isSelected = false,
  });

  /// This constructor requires all instance variables
  Playlist.fullConstructor({
    required this.id,
    required this.title,
    required this.url,
    required this.playlistType,
    required this.playlistQuality,
    required this.downloadPath,
    required this.isSelected,
  });

  Audio? getNextPlayableAudio(Audio currentAudio) {
    int currentAudioIndex = playableAudioLst
        .indexWhere((item) => item.audioFileName == currentAudio.audioFileName);

    if (currentAudioIndex == -1) {
      return null;
    }

    if (currentAudioIndex == playableAudioLst.length - 1) {
      return null;
    }

    return playableAudioLst[currentAudioIndex + 1];
  }

  /// Factory constructor: creates an instance of Playlist from a
  /// JSON object
  factory Playlist.fromJson(Map<String, dynamic> json) {
    Playlist playlist = Playlist.fullConstructor(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      playlistType: PlaylistType.values.firstWhere(
        (e) => e.toString().split('.').last == json['playlistType'],
        orElse: () => PlaylistType.youtube,
      ),
      playlistQuality: PlaylistQuality.values.firstWhere(
        (e) => e.toString().split('.').last == json['playlistQuality'],
        orElse: () => PlaylistQuality.voice,
      ),
      downloadPath: json['downloadPath'],
      isSelected: json['isSelected'],
    );

    // Deserialize the Audio instances in the
    // downloadedAudioLst
    if (json['downloadedAudioLst'] != null) {
      for (var audioJson in json['downloadedAudioLst']) {
        Audio audio = Audio.fromJson(audioJson);
        audio.enclosingPlaylist = playlist;
        playlist.downloadedAudioLst.add(audio);
      }
    }

    // Deserialize the Audio instances in the
    // playableAudioLst
    if (json['playableAudioLst'] != null) {
      for (var audioJson in json['playableAudioLst']) {
        Audio audio = Audio.fromJson(audioJson);
        audio.enclosingPlaylist = playlist;
        playlist.playableAudioLst.add(audio);
      }
    }

    return playlist;
  }

  // Method: converts an instance of Playlist to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'playlistType': playlistType.toString().split('.').last,
      'playlistQuality': playlistQuality.toString().split('.').last,
      'downloadPath': downloadPath,
      'downloadedAudioLst':
          downloadedAudioLst.map((audio) => audio.toJson()).toList(),
      'playableAudioLst':
          playableAudioLst.map((audio) => audio.toJson()).toList(),
      'isSelected': isSelected,
    };
  }

  void setCurrentPlayableAudio(Audio audio) {
    currentPlayableAudioIndex = playableAudioLst
        .indexWhere((item) => item.audioFileName == audio.audioFileName);
  }

  /// Adds the downloaded audio to the downloadedAudioLst and to
  /// the playableAudioLst.
  void addDownloadedAudio(Audio downloadedAudio) {
    downloadedAudio.enclosingPlaylist = this;
    downloadedAudioLst.add(downloadedAudio);
    playableAudioLst.insert(0, downloadedAudio);
  }

  /// Adds the moved audio to the downloadedAudioLst and to the
  /// playableAudioLst. Adding the audio to the downloadedAudioLst
  /// is necessary even if the audio was not downloaded from this
  /// playlist so that if the audio is then moved to another
  /// playlist, the moving action will not fail since moving is
  /// done from the downloadedAudioLst.
  ///
  /// Before, sets the enclosingPlaylist to this as well as the
  /// movedFromPlaylistTitle.
  void addMovedAudio({
    required Audio movedAudio,
    required String movedFromPlaylistTitle,
  }) {
    // Creating a copy of the audio to be moved so that the passed
    // original audio will not be modified by this method.
    Audio movedAudioCopy = movedAudio.copy();

    Audio? existingDownloadedAudio;

    try {
      existingDownloadedAudio = downloadedAudioLst.firstWhere(
        (audio) => audio.audioFileName == movedAudio.audioFileName,
      );
    } catch (e) {
      existingDownloadedAudio = null;
    }

    movedAudioCopy.enclosingPlaylist = this;
    movedAudioCopy.movedFromPlaylistTitle = movedFromPlaylistTitle;

    if (existingDownloadedAudio != null) {
      // the case if the audio was moved to this playlist a first
      // time and then moved back to the source playlist or moved
      // to another playlist and then moved back to this playlist.
      existingDownloadedAudio.movedFromPlaylistTitle = movedFromPlaylistTitle;
      existingDownloadedAudio.movedToPlaylistTitle = title;
      existingDownloadedAudio.enclosingPlaylist = this;
      playableAudioLst.insert(0, existingDownloadedAudio);
    } else {
      downloadedAudioLst.add(movedAudioCopy);
      playableAudioLst.insert(0, movedAudioCopy);
    }
  }

  /// Removes the downloaded audio from the downloadedAudioLst
  /// and from the playableAudioLst.
  ///
  /// This is used when the downloaded audio is moved to another
  /// playlist and is not kept in downloadedAudioLst of the source
  /// playlist. In this case, the user is advised to remove the
  /// corresponding video from the playlist on Youtube.
  void removeDownloadedAudioFromDownloadAndPlayableAudioLst({
    required Audio downloadedAudio,
  }) {
    // removes from the list all audios with the same audioFileName
    downloadedAudioLst.removeWhere(
        (Audio audio) => audio.audioFileName == downloadedAudio.audioFileName);

    // removes from the list all audios with the same audioFileName
    playableAudioLst.removeWhere(
        (Audio audio) => audio.audioFileName == downloadedAudio.audioFileName);
  }

  /// Removes the downloaded audio from the playableAudioLst only.
  ///
  /// This is used when the downloaded audio is moved to another
  /// playlist and is keeped in downloadedAudioLst of the source
  /// playlist so that it will not be downloaded again.
  void removeDownloadedAudioFromPlayableAudioLstOnly({
    required Audio downloadedAudio,
  }) {
    playableAudioLst.remove(downloadedAudio);
  }

  void setMovedAudioToPlaylistTitle({
    required String audioFileName,
    required String movedToPlaylistTitle,
  }) {
    downloadedAudioLst
        .firstWhere((audio) => audio.audioFileName == audioFileName)
        .movedToPlaylistTitle = movedToPlaylistTitle;
  }

  /// Used when uploading the Playlist json file. Since the
  /// json file contains the playable audio list in the right
  /// order, using add and not insert maintains the right order !
  void addPlayableAudio(Audio playableAudio) {
    playableAudio.enclosingPlaylist = this;
    playableAudioLst.add(playableAudio);
  }

  void removePlayableAudio(Audio playableAudio) {
    playableAudioLst.remove(playableAudio);
  }

  @override
  String toString() {
    return '$title isSelected: $isSelected';
  }

  String getPlaylistDownloadFilePathName() {
    return '$downloadPath${Platform.pathSeparator}$title.json';
  }

  DateTime? getLastDownloadDateTime() {
    Audio? lastDownloadedAudio =
        downloadedAudioLst.isNotEmpty ? downloadedAudioLst.last : null;

    return (lastDownloadedAudio != null)
        ? lastDownloadedAudio.audioDownloadDateTime
        : null;
  }

  Duration getPlayableAudioLstTotalDuration() {
    Duration totalDuration = Duration.zero;

    for (Audio audio in playableAudioLst) {
      totalDuration += audio.audioDuration ?? Duration.zero;
    }

    return totalDuration;
  }

  int getPlayableAudioLstTotalFileSize() {
    int totalFileSize = 0;

    for (Audio audio in playableAudioLst) {
      totalFileSize += audio.audioFileSize;
    }

    return totalFileSize;
  }

  /// Removes from the playableAudioLst the audios that are no longer
  /// in the playlist download path.
  ///
  /// Returns the number of audios removed from the playable audio
  /// list.
  int updatePlayableAudioLst() {
    int removedPlayableAudioNumber = 0;

    // since we are removing items from the list, we need to make a
    // copy of the list because we cannot iterate over a list that
    // is being modified.
    List<Audio> copyAudioLst = List<Audio>.from(playableAudioLst);

    for (Audio audio in copyAudioLst) {
      if (!File(audio.filePathName).existsSync()) {
        playableAudioLst.remove(audio);
        removedPlayableAudioNumber++;
      }
    }

    return removedPlayableAudioNumber;
  }

  void sortDownloadedAudioLst({
    required AudioSortCriterion audioSortCriteriomn,
    required bool isSortAscending,
  }) {
    _sortAudioLst(
      lstToSort: downloadedAudioLst,
      audioSortCriteriomn: audioSortCriteriomn,
      isSortAscending: isSortAscending,
    );
  }

  void sortPlayableAudioLst({
    required AudioSortCriterion audioSortCriteriomn,
    required bool isSortAscending,
  }) {
    _sortAudioLst(
      lstToSort: playableAudioLst,
      audioSortCriteriomn: audioSortCriteriomn,
      isSortAscending: isSortAscending,
    );
  }

  void _sortAudioLst({
    required List<Audio> lstToSort,
    required AudioSortCriterion audioSortCriteriomn,
    required bool isSortAscending,
  }) {
    lstToSort.sort((a, b) {
      dynamic aValue;
      dynamic bValue;

      switch (audioSortCriteriomn) {
        case AudioSortCriterion.validVideoTitle:
          aValue = a.validVideoTitle;
          bValue = b.validVideoTitle;
          break;
        case AudioSortCriterion.audioDownloadDateTime:
          aValue = a.audioDownloadDateTime;
          bValue = b.audioDownloadDateTime;
          break;
        default:
          break;
      }

      int compareResult = aValue.compareTo(bValue);

      return isSortAscending ? compareResult : -compareResult;
    });
  }

  void renameDownloadedAndPlayableAudioFile({
    required String oldFileName,
    required String newFileName,
  }) {
    Audio? existingDownloadedAudio;

    try {
      existingDownloadedAudio = downloadedAudioLst.firstWhere(
        (audio) => audio.audioFileName == oldFileName,
      );
    } catch (e) {
      existingDownloadedAudio = null;
    }

    if (existingDownloadedAudio != null) {
      existingDownloadedAudio.audioFileName = newFileName;
    }

    Audio? existingPlayableAudio;

    try {
      existingPlayableAudio = playableAudioLst.firstWhere(
        (audio) => audio.audioFileName == oldFileName,
      );
    } catch (e) {
      existingPlayableAudio = null;
    }

    if (existingPlayableAudio != null) {
      existingPlayableAudio.audioFileName = newFileName;
    }
  }
}

class Audio {
  static DateFormat downloadDatePrefixFormatter = DateFormat('yyMMdd');
  static DateFormat downloadDateTimePrefixFormatter =
      DateFormat('yyMMdd-HHmmss');
  static DateFormat uploadDateSuffixFormatter = DateFormat('yy-MM-dd');

  // Playlist in which the video is referenced
  Playlist? enclosingPlaylist;

  // Playlist from which the Audio was moved
  String? movedFromPlaylistTitle;

  // Playlist to which the Audio was moved
  String? movedToPlaylistTitle;

  // Video title displayed on Youtube
  final String originalVideoTitle;

  // Video title which does not contain invalid characters which
  // would cause the audio file name to genertate an file creation
  // exception
  String validVideoTitle;

  String compactVideoDescription;

  // Url referencing the video from which rhe audio was extracted
  final String videoUrl;

  // Audio download date time
  final DateTime audioDownloadDateTime;

  // Duration in which the audio was downloaded
  Duration? audioDownloadDuration;

  // Date at which the video containing the audio was added on
  // Youtube
  final DateTime videoUploadDate;

  // Stored audio file name
  String audioFileName;

  // Duration of downloaded audio
  final Duration? audioDuration;

  // Audio file size in bytes
  int audioFileSize = 0;
  set fileSize(int size) {
    audioFileSize = size;
    audioDownloadSpeed = (audioFileSize == 0 || audioDownloadDuration == null)
        ? 0
        : (audioFileSize / audioDownloadDuration!.inMicroseconds * 1000000)
            .round();
  }

  set downloadDuration(Duration downloadDuration) {
    audioDownloadDuration = downloadDuration;
    audioDownloadSpeed = (audioFileSize == 0 || audioDownloadDuration == null)
        ? 0
        : (audioFileSize / audioDownloadDuration!.inMicroseconds * 1000000)
            .round();
  }

  // Speed at which the audio was downloaded in bytes per second
  late int audioDownloadSpeed;

  // State of the audio

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;
  set isPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
    _isPaused = false;
  }

  bool _isPaused = false;
  bool get isPaused => _isPaused;

  // AudioPlayer of the current audio. Enables to play, pause, stop
  // the audio. It is initialized when the audio is played for the
  // first time.
  AudioPlayer? audioPlayer;

  double audioPlaySpeed = kAudioDefaultSpeed;

  bool isMusicQuality = false;

  bool isPlayingOnGlobalAudioPlayerVM = false;
  int audioPositionSeconds;

  Audio({
    required this.enclosingPlaylist,
    required this.originalVideoTitle,
    required this.compactVideoDescription,
    required this.videoUrl,
    required this.audioDownloadDateTime,
    this.audioDownloadDuration,
    required this.videoUploadDate,
    this.audioDuration,
  })  : validVideoTitle = createValidVideoTitle(originalVideoTitle),
        audioFileName =
            '${buildDownloadDatePrefix(audioDownloadDateTime)}${createValidVideoTitle(originalVideoTitle)} ${buildUploadDateSuffix(videoUploadDate)}.mp3',
        audioPositionSeconds = 0;

  /// This constructor requires all instance variables. It is used
  /// by the fromJson factory constructor.
  Audio.fullConstructor({
    required this.enclosingPlaylist,
    required this.movedFromPlaylistTitle,
    required this.movedToPlaylistTitle,
    required this.originalVideoTitle,
    required this.compactVideoDescription,
    required this.validVideoTitle,
    required this.videoUrl,
    required this.audioDownloadDateTime,
    required this.audioDownloadDuration,
    required this.audioDownloadSpeed,
    required this.videoUploadDate,
    required this.audioDuration,
    required this.isMusicQuality,
    required this.audioFileName,
    required this.audioFileSize,
  }) : audioPositionSeconds = 0;

  /// Returns a copy of the current Audio instance
  Audio copy() {
    return Audio.fullConstructor(
      enclosingPlaylist: enclosingPlaylist,
      movedFromPlaylistTitle: movedFromPlaylistTitle,
      movedToPlaylistTitle: movedToPlaylistTitle,
      originalVideoTitle: originalVideoTitle,
      compactVideoDescription: compactVideoDescription,
      validVideoTitle: validVideoTitle,
      videoUrl: videoUrl,
      audioDownloadDateTime: audioDownloadDateTime,
      audioDownloadDuration: audioDownloadDuration,
      audioDownloadSpeed: audioDownloadSpeed,
      videoUploadDate: videoUploadDate,
      audioDuration: audioDuration,
      isMusicQuality: isMusicQuality,
      audioFileName: audioFileName,
      audioFileSize: audioFileSize,
    );
  }

  /// Factory constructor: creates an instance of Audio from a
  /// JSON object
  factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio.fullConstructor(
      enclosingPlaylist:
          null, // You'll need to handle this separately, see note below
      movedFromPlaylistTitle: json['movedFromPlaylistTitle'],
      movedToPlaylistTitle: json['movedToPlaylistTitle'],
      originalVideoTitle: json['originalVideoTitle'],
      compactVideoDescription: json['compactVideoDescription'] ?? '',
      validVideoTitle: json['validVideoTitle'],
      videoUrl: json['videoUrl'],
      audioDownloadDateTime: DateTime.parse(json['audioDownloadDateTime']),
      audioDownloadDuration:
          Duration(milliseconds: json['audioDownloadDurationMs']),
      audioDownloadSpeed: (json['audioDownloadSpeed'] < 0)
          ? double.infinity
          : json['audioDownloadSpeed'],
      videoUploadDate: DateTime.parse(json['videoUploadDate']),
      audioDuration: Duration(milliseconds: json['audioDurationMs'] ?? 0),
      isMusicQuality: json['isMusicQuality'] ?? false,
      audioFileName: json['audioFileName'],
      audioFileSize: json['audioFileSize'],
    );
  }

  // Method: converts an instance of Audio to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'movedFromPlaylistTitle': movedFromPlaylistTitle,
      'movedToPlaylistTitle': movedToPlaylistTitle,
      'originalVideoTitle': originalVideoTitle,
      'compactVideoDescription': compactVideoDescription,
      'validVideoTitle': validVideoTitle,
      'videoUrl': videoUrl,
      'audioDownloadDateTime': audioDownloadDateTime.toIso8601String(),
      'audioDownloadDurationMs': audioDownloadDuration?.inMilliseconds,
      'audioDownloadSpeed':
          (audioDownloadSpeed.isFinite) ? audioDownloadSpeed : -1.0,
      'videoUploadDate': videoUploadDate.toIso8601String(),
      'audioDurationMs': audioDuration?.inMilliseconds,
      'isMusicQuality': isMusicQuality,
      'audioFileName': audioFileName,
      'audioFileSize': audioFileSize,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Audio && other.videoUrl == videoUrl;
  }

  @override
  int get hashCode => videoUrl.hashCode;

  void invertPaused() {
    _isPaused = !_isPaused;
  }

  String get filePathName {
    return '${enclosingPlaylist!.downloadPath}${Platform.pathSeparator}$audioFileName';
  }

  static String buildDownloadDatePrefix(DateTime downloadDate) {
    String formattedDateStr = (kAudioFileNamePrefixIncludeTime)
        ? downloadDateTimePrefixFormatter.format(downloadDate)
        : downloadDatePrefixFormatter.format(downloadDate);

    return '$formattedDateStr-';
  }

  static String buildUploadDateSuffix(DateTime uploadDate) {
    String formattedDateStr = uploadDateSuffixFormatter.format(uploadDate);

    return formattedDateStr;
  }

  /// Removes illegal file name characters from the original
  /// video title aswell non-ascii characters. This causes
  /// the valid video title to be efficient when sorting
  /// the audio by their title.
  static String createValidVideoTitle(String originalVideoTitle) {
    // Replace '|' by ' if '|' is located at end of file name
    if (originalVideoTitle.endsWith('|')) {
      originalVideoTitle =
          originalVideoTitle.substring(0, originalVideoTitle.length - 1);
    }

    // Replace '||' by '_' since YoutubeDL replaces '||' by '_'
    originalVideoTitle = originalVideoTitle.replaceAll('||', '|');

    // Replace '//' by '_' since YoutubeDL replaces '//' by '_'
    originalVideoTitle = originalVideoTitle.replaceAll('//', '/');

    final charToReplace = {
      '\\': '',
      '/': '_', // since YoutubeDL replaces '/' by '_'
      ':': ' -', // since YoutubeDL replaces ':' by ' -'
      '*': ' ',
      // '.': '', point is not illegal in file name
      '?': '',
      '"': "'", // since YoutubeDL replaces " by '
      '<': '',
      '>': '',
      '|': '_', // since YoutubeDL replaces '|' by '_'
      // "'": '_', apostrophe is not illegal in file name
    };

    // Replace unauthorized characters
    originalVideoTitle = originalVideoTitle.replaceAllMapped(
        RegExp(r'[\\/:*?"<>|]'),
        (match) => charToReplace[match.group(0)] ?? '');

    // Replace 'œ' with 'oe'
    originalVideoTitle = originalVideoTitle.replaceAll(RegExp(r'[œ]'), 'oe');

    // Replace 'Œ' with 'OE'
    originalVideoTitle = originalVideoTitle.replaceAll(RegExp(r'[Œ]'), 'OE');

    // Remove any non-English or non-French characters
    originalVideoTitle =
        originalVideoTitle.replaceAll(RegExp(r'[^\x00-\x7FÀ-ÿ‘’]'), '');

    return originalVideoTitle.trim();
  }

  @override
  String toString() {
    return 'Audio: $validVideoTitle';
  }
}

/// Used in the AudioPlayerView screen to manage the audio playing
/// position modifications.
class AudioGlobalPlayerVM extends ChangeNotifier {
  Audio? _currentAudio;
  late AudioPlayer _audioPlayer;
  Duration _currentAudioTotalDuration = const Duration();
  Duration _currentAudioPosition = const Duration();

  Duration get currentAudioPosition => _currentAudioPosition;
  Duration get currentAudioTotalDuration => _currentAudioTotalDuration;
  Duration get currentAudioRemainingDuration =>
      _currentAudioTotalDuration - _currentAudioPosition;

  bool get isPlaying => _audioPlayer.state == PlayerState.playing;

  AudioGlobalPlayerVM() {
    // the next line is necessary since _audioPlayer.dispose() is
    // called in _initializePlayer()
    _audioPlayer = AudioPlayer();

    _initializePlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();

    super.dispose();
  }

  void setCurrentAudio(Audio audio) {
    _currentAudio = audio;

    // without setting _currentAudioTotalDuration to the
    // the next instruction causes an error: Failed assertion: line 194
    // pos 15: 'value >= min && value <= max': Value 3.0 is not between
    // minimum 0.0 and maximum 0.0
    _currentAudioTotalDuration = audio.audioDuration ?? const Duration();

    _currentAudioPosition = Duration(seconds: audio.audioPositionSeconds);
    audio.enclosingPlaylist!.setCurrentPlayableAudio(audio);

    _initializePlayer();
  }

  void _initializePlayer() {
    _audioPlayer.dispose();
    _audioPlayer = AudioPlayer();

    // Assuming filePath is the full path to your audio file
    String audioFilePathName = _currentAudio?.filePathName ?? '';

    // Check if the file exists before attempting to play it
    if (audioFilePathName.isNotEmpty && File(audioFilePathName).existsSync()) {
      _audioPlayer.onDurationChanged.listen((duration) {
        _currentAudioTotalDuration = duration;
        notifyListeners();
      });

      _audioPlayer.onPositionChanged.listen((position) {
        if (isPlaying) {
          // this test avoids that when selecting another audio
          // the selected audio position is set to 0 since the
          // passed position value is 0 !
          _currentAudioPosition = position;
          updateAndSaveCurrentAudio();
        }

        _audioPlayer.onPlayerComplete.listen((event) {
          // Play next audio when current audio finishes.
          playNextAudio();
        });

        notifyListeners();
      });
    }
  }

  Future<void> playNextAudio() async {
    await _setNextAudio();
    await playFromCurrentAudioFile();

    notifyListeners();
  }

  Future<void> _setNextAudio() async {
    Audio? nextAudio = _currentAudio!.enclosingPlaylist!.getNextPlayableAudio(
      _currentAudio!,
    );

    if (nextAudio == null) {
      return;
    }

    setCurrentAudio(nextAudio);
  }

  Future<void> playFromCurrentAudioFile() async {
    if (_currentAudio == null) {
      // the case if the user has selected the AudioPlayerView screen
      // without yet having choosed an audio file to listen. Later, you
      // will store the last played audio file in the settings.
      return;
    }

    String audioFilePathName = _currentAudio!.filePathName;

    // Check if the file exists before attempting to play it
    if (File(audioFilePathName).existsSync()) {
      await _audioPlayer.play(DeviceFileSource(
          audioFilePathName)); // <-- Directly using play method
      await _audioPlayer.setPlaybackRate(_currentAudio!.audioPlaySpeed);
      _currentAudio!.isPlayingOnGlobalAudioPlayerVM = true;

      notifyListeners();
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    _currentAudio!.isPlayingOnGlobalAudioPlayerVM = false;

    notifyListeners();
  }

  /// Method called when the user clicks on the '<<' or '>>' buttons
  Future<void> changeAudioPlayPosition(
      Duration positiveOrNegativeDuration) async {
    Duration currentAudioDuration =
        _currentAudio!.audioDuration ?? Duration.zero;
    Duration newAudioPosition =
        _currentAudioPosition + positiveOrNegativeDuration;

    // Check if the new audio position is within the audio duration.
    // If not, set the audio position to the beginning or the end
    // of the audio. This is necessary to avoid a slider error.
    //
    // This fixes the bug when clicking on >> after having clicked
    // on >| or clicking on << after having clicked on |<.
    if (newAudioPosition < Duration.zero) {
      _currentAudioPosition = Duration.zero;
    } else if (newAudioPosition > currentAudioDuration) {
      // subtracting 1 second is necessary to avoid a slider error
      _currentAudioPosition = currentAudioDuration - const Duration(seconds: 1);
    } else {
      _currentAudioPosition = newAudioPosition;
    }

    // necessary so that the audio position is stored on the
    // audio
    _currentAudio!.audioPositionSeconds = _currentAudioPosition.inSeconds;

    await _audioPlayer.seek(_currentAudioPosition);

    notifyListeners();
  }

  /// Method called when the user clicks on the audio slider
  Future<void> goToAudioPlayPosition(Duration position) async {
    _currentAudioPosition = position; // Immediately update the position

    // necessary so that the audio position is stored on the
    // audio
    _currentAudio!.audioPositionSeconds = _currentAudioPosition.inSeconds;

    await _audioPlayer.seek(position);

    notifyListeners();
  }

  Future<void> skipToStart() async {
    _currentAudioPosition = Duration.zero;
    // necessary so that the audio position is stored on the
    // audio
    _currentAudio!.audioPositionSeconds = _currentAudioPosition.inSeconds;

    await _audioPlayer.seek(_currentAudioPosition);

    notifyListeners();
  }

  Future<void> skipToEnd() async {
    _currentAudioPosition = _currentAudioTotalDuration;
    // necessary so that the audio position is stored on the
    // audio
    _currentAudio!.audioPositionSeconds = _currentAudioPosition.inSeconds;
    _currentAudio!.isPlayingOnGlobalAudioPlayerVM = false;

    await _audioPlayer.seek(_currentAudioTotalDuration);

    notifyListeners();
  }

  void updateAndSaveCurrentAudio() {
    _currentAudio!.audioPositionSeconds = _currentAudioPosition.inSeconds;
    print(
        'updateAndSaveCurrentAudio() currentAudio!.audioPositionSeconds: ${_currentAudio!.audioPositionSeconds}');
    // Playlist? currentAudioPlaylist = currentAudio!.enclosingPlaylist;
    // JsonDataService.saveToFile(
    //   model: currentAudioPlaylist!,
    //   path: currentAudioPlaylist.getPlaylistDownloadFilePathName(),
    // );
  }
}

class AudioPlayerView extends StatefulWidget {
  final List<Audio> audioLst;

  AudioPlayerView({
    Key? key,
  })  : audioLst = _createAudiosLst(),
        super(key: key);

  static Playlist _createPlaylist() {
    final pl = Playlist(
      url: 'url',
      playlistType: PlaylistType.local,
      playlistQuality: PlaylistQuality.voice,
    );
    pl.downloadPath =
        "C:\\Users\\Jean-Pierre\\Downloads\\Audio\\audio_learn_short";
    return pl;
  }

  static List<Audio> _createAudiosLst() {
    Playlist playlist = _createPlaylist();

    final audioOne = Audio(
      enclosingPlaylist: playlist,
      originalVideoTitle:
          '15 minutes de Janco pour retourner un climatosceptique',
      compactVideoDescription: 'compactVideoDescription',
      videoUrl: 'videoUrl',
      audioDownloadDateTime: DateTime.now(),
      audioDownloadDuration: Duration.zero,
      videoUploadDate: DateTime.now(),
      audioDuration: const Duration(seconds: 873),
    );

    audioOne.audioFileName =
        "231004-214307-15 minutes de Janco pour retourner un climatosceptique 23-10-01.mp3";

    final audioTwo = Audio(
      enclosingPlaylist: playlist,
      originalVideoTitle: 'Avoir accès à DALLE 3 gratuitement et en un click',
      compactVideoDescription: 'compactVideoDescription',
      videoUrl: 'videoUrl',
      audioDownloadDateTime: DateTime.now(),
      audioDownloadDuration: Duration.zero,
      videoUploadDate: DateTime.now(),
      audioDuration: const Duration(seconds: 618),
    );

    audioTwo.audioFileName =
        "231031-132823-Avoir accès à DALLE 3 gratuitement et en un click 23-09-30.mp3";

    final audioThree = Audio(
      enclosingPlaylist: playlist,
      originalVideoTitle: "Limites de l'IA",
      compactVideoDescription: 'compactVideoDescription',
      videoUrl: 'videoUrl',
      audioDownloadDateTime: DateTime.now(),
      audioDownloadDuration: Duration.zero,
      videoUploadDate: DateTime.now(),
      audioDuration: const Duration(seconds: 968),
    );

    audioThree.audioFileName = "231031-135647-Limites de l’IA 23-10-01.mp3";
    List<Audio> audioLst = [audioOne, audioTwo, audioThree];
    playlist.playableAudioLst = audioLst;

    return audioLst;
  }

  @override
  _AudioPlayerViewState createState() => _AudioPlayerViewState();
}

class _AudioPlayerViewState extends State<AudioPlayerView> {
  final double _audioIconSizeMedium = 60;
  final double _audioIconSizeLarge = 90;

  // final TextEditingController _audioPositionController =
  //     TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AudioGlobalPlayerVM(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Audio Player'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // TextField(
                //   decoration: const InputDecoration(
                //     border: OutlineInputBorder(),
                //     labelText: 'Initial audio position in seconds',
                //   ),
                //   controller: _audioPositionController,
                // ),
                // const SizedBox(height: 2.0),
                // Builder(builder: (BuildContext context) {
                //   // By wrapping your TextButton with a Builder, you're
                //   // ensuring that the context passed to the Provider.of
                //   // method is a direct child of the ChangeNotifierProvider,
                //   // which should resolve the ProviderNotFoundException
                //   // error.
                //   return TextButton(
                //     onPressed: () async {
                //       await Provider.of<AudioGlobalPlayerVM>(context,
                //               listen: false)
                //           .goToAudioPlayPosition(Duration(
                //               seconds: int.parse(
                //                   _audioPositionController.text.isEmpty
                //                       ? '0'
                //                       : _audioPositionController.text)));
                //     },
                //     child: const Text('Seek to position'),
                //   );
                // }),
                const Text('Audio List'),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: widget.audioLst.length,
                    itemBuilder: (context, index) {
                      Audio audioItem = widget.audioLst[index];
                      return ListTile(
                        title: Text(audioItem.validVideoTitle),
                        onTap: () async {
                          AudioGlobalPlayerVM audioGlobalPlayerVM =
                              Provider.of<AudioGlobalPlayerVM>(context,
                                  listen: false);
                          audioGlobalPlayerVM.setCurrentAudio(audioItem);
                          await audioGlobalPlayerVM.goToAudioPlayPosition(
                              Duration(
                                  seconds: audioItem.audioPositionSeconds));
                          await audioGlobalPlayerVM.playFromCurrentAudioFile();
                        },
                      );
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 10.0),
            Column(
              children: [
                const SizedBox(height: 16.0),
                _buildSlider(),
                _buildPositions(),
              ],
            ),
            _buildPlayButtons(),
            _buildPositionButtons()
          ],
        ),
      ),
    );
  }

  Widget _buildSlider() {
    return Consumer<AudioGlobalPlayerVM>(
      builder: (context, audioGlobalPlayerVM, child) {
        // Obtaining the slider values here (when audioGlobalPlayerVM
        // call notifyListeners()) avoids that the slider generate
        // a 'Value xxx.x is not between minimum 0.0 and maximum 0.0'
        // error
        double sliderValue =
            audioGlobalPlayerVM.currentAudioPosition.inSeconds.toDouble();
        double maxDuration =
            audioGlobalPlayerVM.currentAudioTotalDuration.inSeconds.toDouble();

        // Ensure the slider value is within the range
        sliderValue = sliderValue.clamp(0.0, maxDuration);

        return Slider(
          min: 0.0,
          max: maxDuration,
          value: sliderValue,
          onChanged: (double value) async {
            await audioGlobalPlayerVM
                .goToAudioPlayPosition(Duration(seconds: value.toInt()));
          },
        );
      },
    );
  }

  Widget _buildPositions() {
    return Consumer<AudioGlobalPlayerVM>(
      builder: (context, audioGlobalPlayerVM, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(audioGlobalPlayerVM.currentAudioPosition),
                style: const TextStyle(fontSize: 20.0),
              ),
              Text(
                _formatDuration(
                    audioGlobalPlayerVM.currentAudioRemainingDuration),
                style: const TextStyle(fontSize: 20.0),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  Widget _buildPlayButtons() {
    return Consumer<AudioGlobalPlayerVM>(
      builder: (context, audioGlobalPlayerVM, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              iconSize: _audioIconSizeMedium,
              onPressed: () async => await audioGlobalPlayerVM.skipToStart(),
              icon: const Icon(Icons.skip_previous),
            ),
            IconButton(
              iconSize: _audioIconSizeLarge,
              onPressed: () async {
                audioGlobalPlayerVM.isPlaying
                    ? await audioGlobalPlayerVM.pause()
                    : await audioGlobalPlayerVM.playFromCurrentAudioFile();
              },
              icon: Icon(audioGlobalPlayerVM.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow),
            ),
            IconButton(
              iconSize: _audioIconSizeMedium,
              onPressed: () async => await audioGlobalPlayerVM.skipToEnd(),
              icon: const Icon(Icons.skip_next),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPositionButtons() {
    return Consumer<AudioGlobalPlayerVM>(
      builder: (context, audioGlobalPlayerVM, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 120,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: _audioIconSizeMedium - 7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: IconButton(
                            iconSize: _audioIconSizeMedium,
                            onPressed: () async => await audioGlobalPlayerVM
                                .changeAudioPlayPosition(
                                    const Duration(minutes: -1)),
                            icon: const Icon(Icons.fast_rewind),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            iconSize: _audioIconSizeMedium,
                            onPressed: () async => await audioGlobalPlayerVM
                                .changeAudioPlayPosition(
                                    const Duration(seconds: -10)),
                            icon: const Icon(Icons.fast_rewind),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            iconSize: _audioIconSizeMedium,
                            onPressed: () async => await audioGlobalPlayerVM
                                .changeAudioPlayPosition(
                                    const Duration(seconds: 10)),
                            icon: const Icon(Icons.fast_forward),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            iconSize: _audioIconSizeMedium,
                            onPressed: () async => await audioGlobalPlayerVM
                                .changeAudioPlayPosition(
                                    const Duration(minutes: 1)),
                            icon: const Icon(Icons.fast_forward),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '1 m',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 21.0),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '10 s',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 21.0),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '10 s',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 21.0),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '1 m',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 21.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
