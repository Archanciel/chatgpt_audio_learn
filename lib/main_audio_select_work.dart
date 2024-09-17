// dart file located in lib\models

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:chatgpt_audio_learn/constants_old.dart';
import 'package:chatgpt_audio_learn/models/playlist.dart';
import 'package:intl/intl.dart';

/// Contains informations of the audio extracted from the video
/// referenced in the enclosing playlist. In fact, the audio is
/// directly downloaded from Youtube.
class Audio {
  static DateFormat downloadDatePrefixFormatter = DateFormat('yyMMdd');
  static DateFormat uploadDateSuffixFormatter = DateFormat('yy-MM-dd');

  // Playlist in which the video is referenced
  Playlist? enclosingPlaylist;

  // Video title displayed on Youtube
  final String originalVideoTitle;

  // Video title which does not contain invalid characters which
  // would cause the audio file name to generate an file creation
  // exception
  final String validVideoTitle;

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
  final String audioFileName;

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

  // AudioPlayer of the current audio
  AudioPlayer? audioPlayer;

  double playSpeed = kAudioDefaultSpeed;

  bool isMusicQuality = false;

  Audio({
    required this.enclosingPlaylist,
    required this.originalVideoTitle,
    required this.videoUrl,
    required this.audioDownloadDateTime,
    this.audioDownloadDuration,
    required this.videoUploadDate,
    this.audioDuration,
  })  : validVideoTitle =
            replaceUnauthorizedDirOrFileNameChars(originalVideoTitle),
        audioFileName =
            '${buildDownloadDatePrefix(audioDownloadDateTime)}${replaceUnauthorizedDirOrFileNameChars(originalVideoTitle)} ${buildUploadDateSuffix(videoUploadDate)}.mp3';

  /// This constructor requires all instance Audioiables
  Audio.fullConstructor({
    required this.enclosingPlaylist,
    required this.originalVideoTitle,
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
  });

  // Factory constructor: creates an instance of Audio from a JSON object
  factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio.fullConstructor(
      enclosingPlaylist:
          null, // You'll need to handle this separately, see note below
      originalVideoTitle: json['originalVideoTitle'],
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
      'originalVideoTitle': originalVideoTitle,
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

  void invertPaused() {
    _isPaused = !_isPaused;
  }

  String get filePathName {
    return '${enclosingPlaylist!.downloadPath}${Platform.pathSeparator}$audioFileName';
  }

  static String buildDownloadDatePrefix(DateTime downloadDate) {
    String formattedDateStr = downloadDatePrefixFormatter.format(downloadDate);

    return '$formattedDateStr-';
  }

  static String buildUploadDateSuffix(DateTime uploadDate) {
    String formattedDateStr = uploadDateSuffixFormatter.format(uploadDate);

    return formattedDateStr;
  }

  static String replaceUnauthorizedDirOrFileNameChars(String rawFileName) {
    // Replace '|' by ' if '|' is located at end of file name
    if (rawFileName.endsWith('|')) {
      rawFileName = rawFileName.substring(0, rawFileName.length - 1);
    }

    // Replace '||' by '_' since YoutubeDL replaces '||' by '_'
    rawFileName = rawFileName.replaceAll('||', '|');

    // Replace '//' by '_' since YoutubeDL replaces '//' by '_'
    rawFileName = rawFileName.replaceAll('//', '/');

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

    // Replace all multiple characters in a string based on translation table created by dictionary
    String validFileName = rawFileName;
    charToReplace.forEach((key, value) {
      validFileName = validFileName.replaceAll(key, value);
    });

    // Since YoutubeDL replaces '?' by ' ', determining if a video whose title
    // ends with '?' has already been downloaded using
    // replaceUnauthorizedDirOrFileNameChars(videoTitle) + '.mp3' can be executed
    // if validFileName.trim() is NOT done.
    return validFileName;
  }
}

// void main(List<String> args) {
//   Playlist playlist = Playlist(url: 'https://example.com/playlist1');
//   List<Audio> audioLst = [];

//   Audio audio1 = Audio(
//       enclosingPlaylist: playlist,
//       originalVideoTitle: 'Title C',
//       videoUrl: 'https://example.com/video1',
//       audioDownloadDateTime: DateTime(2023, 3, 20),
//       videoUploadDate: DateTime(2023, 2, 20),
//       audioDuration: const Duration(seconds: 1000));

//   audio1.audioDownloadDuration = Duration(seconds: 100);
//   audio1.audioDownloadSpeed = 1000000;
//   audio1.isMusicQuality = true;
//   audio1.audioFileSize = 10000;

//   audioLst.add(audio1);

//   Audio audio2 = Audio(
//       enclosingPlaylist: playlist,
//       originalVideoTitle: 'Audio Brave',
//       videoUrl: 'https://example.com/video3',
//       audioDownloadDateTime: DateTime(2023, 3, 18),
//       videoUploadDate: DateTime(2023, 3, 20),
//       audioDuration: const Duration(seconds: 5000));

//   audio2.audioDownloadDuration = Duration(seconds: 250);
//   audio2.audioDownloadSpeed = 2000000;
//   audio2.isMusicQuality = false;
//   audio2.audioFileSize = 50000;

//   audioLst.add(audio2);

//   Audio audio3 = Audio(
//       enclosingPlaylist: playlist,
//       originalVideoTitle: 'Titre A',
//       videoUrl: 'https://example.com/video2',
//       audioDownloadDateTime: DateTime(2023, 3, 25),
//       videoUploadDate: DateTime(2022, 3, 20),
//       audioDuration: const Duration(seconds: 2000));

//   audio3.audioDownloadDuration = Duration(seconds: 100);
//   audio3.audioDownloadSpeed = 2000000;
//   audio3.isMusicQuality = false;
//   audio3.audioFileSize = 20000;

//   audioLst.add(audio3);
// }

List<Audio> sortAudioLstByVideoUploadDate({
  required List<Audio> audioLst,
  bool asc = true,
}) {
  if (asc) {
    audioLst.sort((a, b) {
      if (a.videoUploadDate.isBefore(b.videoUploadDate)) {
        return -1;
      } else if (a.videoUploadDate.isAfter(b.videoUploadDate)) {
        return 1;
      } else {
        return 0;
      }
    });
  } else {
    audioLst.sort((a, b) {
      if (a.videoUploadDate.isBefore(b.videoUploadDate)) {
        return 1;
      } else if (a.videoUploadDate.isAfter(b.videoUploadDate)) {
        return -1;
      } else {
        return 0;
      }
    });
  }

  return audioLst;
}

List<Audio> sortAudioLstByDownloadDate({
  required List<Audio> audioLst,
  bool asc = true,
}) {
  if (asc) {
    audioLst.sort((a, b) {
      if (a.audioDownloadDateTime.isBefore(b.audioDownloadDateTime)) {
        return -1;
      } else if (a.audioDownloadDateTime.isAfter(b.audioDownloadDateTime)) {
        return 1;
      } else {
        return 0;
      }
    });
  } else {
    audioLst.sort((a, b) {
      if (a.audioDownloadDateTime.isBefore(b.audioDownloadDateTime)) {
        return 1;
      } else if (a.audioDownloadDateTime.isAfter(b.audioDownloadDateTime)) {
        return -1;
      } else {
        return 0;
      }
    });
  }

  return audioLst;
}

List<Audio> sortAudioLstByTitle({
  required List<Audio> audioLst,
  bool asc = true,
}) {
  if (asc) {
    audioLst.sort((a, b) {
      return a.validVideoTitle.compareTo(b.validVideoTitle);
    });
  } else {
    audioLst.sort((a, b) {
      return b.validVideoTitle.compareTo(a.validVideoTitle);
    });
  }

  return audioLst;
}

List<Audio> sortAudioLstByDuration({
  required List<Audio> audioLst,
  bool asc = true,
}) {
  if (asc) {
    audioLst.sort((a, b) {
      if (a.audioDuration!.inMilliseconds < b.audioDuration!.inMilliseconds) {
        return -1;
      } else if (a.audioDuration!.inMilliseconds >
          b.audioDuration!.inMilliseconds) {
        return 1;
      } else {
        return 0;
      }
    });
  } else {
    audioLst.sort((a, b) {
      if (a.audioDuration!.inMilliseconds > b.audioDuration!.inMilliseconds) {
        return -1;
      } else if (a.audioDuration!.inMilliseconds <
          b.audioDuration!.inMilliseconds) {
        return 1;
      } else {
        return 0;
      }
    });
  }

  return audioLst;
}

List<Audio> sortAudioLstByDownloadDuration({
  required List<Audio> audioLst,
  bool asc = true,
}) {
  if (asc) {
    audioLst.sort((a, b) {
      if (a.audioDownloadDuration!.inMilliseconds <
          b.audioDownloadDuration!.inMilliseconds) {
        return -1;
      } else if (a.audioDownloadDuration!.inMilliseconds >
          b.audioDownloadDuration!.inMilliseconds) {
        return 1;
      } else {
        return 0;
      }
    });
  } else {
    audioLst.sort((a, b) {
      if (a.audioDownloadDuration!.inMilliseconds >
          b.audioDownloadDuration!.inMilliseconds) {
        return -1;
      } else if (a.audioDownloadDuration!.inMilliseconds <
          b.audioDownloadDuration!.inMilliseconds) {
        return 1;
      } else {
        return 0;
      }
    });
  }

  return audioLst;
}

List<Audio> sortAudioLstByDownloadSpeed({
  required List<Audio> audioLst,
  bool asc = true,
}) {
  if (asc) {
    audioLst.sort((a, b) {
      if (a.audioDownloadSpeed < b.audioDownloadSpeed) {
        return -1;
      } else if (a.audioDownloadSpeed > b.audioDownloadSpeed) {
        return 1;
      } else {
        return 0;
      }
    });
  } else {
    audioLst.sort((a, b) {
      if (a.audioDownloadSpeed < b.audioDownloadSpeed) {
        return -1;
      } else if (a.audioDownloadSpeed > b.audioDownloadSpeed) {
        return 1;
      } else {
        return 0;
      }
    });
  }

  return audioLst;
}

List<Audio> sortAudioLstByFileSize({
  required List<Audio> audioLst,
  bool asc = true,
}) {
  if (asc) {
    audioLst.sort((a, b) {
      if (a.audioFileSize < b.audioFileSize) {
        return -1;
      } else if (a.audioFileSize > b.audioFileSize) {
        return 1;
      } else {
        return 0;
      }
    });
  } else {
    audioLst.sort((a, b) {
      if (a.audioFileSize < b.audioFileSize) {
        return 1;
      } else if (a.audioFileSize > b.audioFileSize) {
        return -1;
      } else {
        return 0;
      }
    });
  }

  return audioLst;
}

List<Audio> sortAudioLstByMusicQuality({
  required List<Audio> audioLst,
  bool asc = true,
}) {
  if (asc) {
    audioLst.sort((a, b) {
      if (a.isMusicQuality && !b.isMusicQuality) {
        return -1;
      } else if (!a.isMusicQuality && b.isMusicQuality) {
        return 1;
      } else {
        return 0;
      }
    });
  } else {
    audioLst.sort((a, b) {
      if (a.isMusicQuality && !b.isMusicQuality) {
        return 1;
      } else if (!a.isMusicQuality && b.isMusicQuality) {
        return -1;
      } else {
        return 0;
      }
    });
  }

  return audioLst;
}

// Method not useful
// List<Audio> sortAudioLstByVideoUrl({
//   required List<Audio> audioLst,
//   bool asc = true,
// }) {
//   if (asc) {
//     audioLst.sort((a, b) {
//       return a.videoUrl.compareTo(b.videoUrl);
//     });
//   } else {
//     audioLst.sort((a, b) {
//       return b.videoUrl.compareTo(a.videoUrl);
//     });
//   }

//   return audioLst;
// }

List<Audio> sortAudioLstByEnclosingPlaylistTitle({
  required List<Audio> audioLst,
  bool asc = true,
}) {
  if (asc) {
    audioLst.sort((a, b) {
      return a.enclosingPlaylist!.title.compareTo(b.enclosingPlaylist!.title);
    });
  } else {
    audioLst.sort((a, b) {
      return b.enclosingPlaylist!.title.compareTo(a.enclosingPlaylist!.title);
    });
  }

  return audioLst;
}

List<Audio> sortAudioLstByAudioDownloadDateTime({
  required List<Audio> audioLst,
  bool asc = true,
}) {
  if (asc) {
    audioLst.sort((a, b) {
      if (a.audioDownloadDateTime.isBefore(b.audioDownloadDateTime)) {
        return -1;
      } else if (a.audioDownloadDateTime.isAfter(b.audioDownloadDateTime)) {
        return 1;
      } else {
        return 0;
      }
    });
  } else {
    audioLst.sort((a, b) {
      if (a.audioDownloadDateTime.isBefore(b.audioDownloadDateTime)) {
        return 1;
      } else if (a.audioDownloadDateTime.isAfter(b.audioDownloadDateTime)) {
        return -1;
      } else {
        return 0;
      }
    });
  }

  return audioLst;
}

List<Audio> filterAudioLstByAudioTitleSubString({
  required List<Audio> audioLst,
  required String audioTitleSubString,
}) {
  return audioLst.where((audio) {
    return audio.originalVideoTitle.contains(audioTitleSubString);
  }).toList();
}

List<Audio> filterAudioLstByAudioDownloadDateTime({
  required List<Audio> audioLst,
  required DateTime startDateTime,
  required DateTime endDateTime,
}) {
  return audioLst.where((audio) {
    return (audio.audioDownloadDateTime.isAfter(startDateTime) ||
            audio.audioDownloadDateTime.isAtSameMomentAs(startDateTime)) &&
        (audio.audioDownloadDateTime.isBefore(endDateTime) ||
            audio.audioDownloadDateTime.isAtSameMomentAs(endDateTime));
  }).toList();
}

List<Audio> filterAudioLstByAudioVideoUploadDateTime({
  required List<Audio> audioLst,
  required DateTime startDateTime,
  required DateTime endDateTime,
}) {
  return audioLst.where((audio) {
    return (audio.videoUploadDate.isAfter(startDateTime) ||
            audio.videoUploadDate.isAtSameMomentAs(startDateTime)) &&
        (audio.videoUploadDate.isBefore(endDateTime) ||
            audio.videoUploadDate.isAtSameMomentAs(endDateTime));
  }).toList();
}

List<Audio> filterAudioLstByAudioFileSize({
  required List<Audio> audioLst,
  required int startFileSize,
  required int endFileSize,
}) {
  return audioLst.where((audio) {
    return (audio.audioFileSize >= startFileSize ||
            audio.audioFileSize == startFileSize) &&
        (audio.audioFileSize <= endFileSize ||
            audio.audioFileSize == endFileSize);
  }).toList();
}

List<Audio> filterAudioLstByMusicQuality({
  required List<Audio> audioLst,
  required bool isMusicQuality,
}) {
  return audioLst.where((audio) {
    return audio.isMusicQuality == isMusicQuality;
  }).toList();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Sort and Filter Dialog')),
        body: const Center(child: MyHomePage()),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const SortAndFilterDialog();
          },
        );
      },
      child: const Text('Open Sort and Filter Dialog'),
    );
  }
}

class SortAndFilterDialog extends StatefulWidget {
  const SortAndFilterDialog({super.key});

  @override
  _SortAndFilterDialogState createState() => _SortAndFilterDialogState();
}

class _SortAndFilterDialogState extends State<SortAndFilterDialog> {
  String _selectedSortingOption = 'Video Upload Date';
  bool _sortAscending = true;
  bool _filterMusicQuality = false;
  final TextEditingController _startFileSizeController =
      TextEditingController();
  final TextEditingController _endFileSizeController = TextEditingController();
  final TextEditingController _audioTitleSubStringController =
      TextEditingController();
  final TextEditingController _startDownloadDateTimeController =
      TextEditingController();
  final TextEditingController _endDownloadDateTimeController =
      TextEditingController();
  final TextEditingController _startUploadDateTimeController =
      TextEditingController();
  final TextEditingController _endUploadDateTimeController =
      TextEditingController();
  String? _audioTitleSubString;
  DateTime _startDownloadDateTime = DateTime.now();
  DateTime _endDownloadDateTime = DateTime.now();
  DateTime _startUploadDateTime = DateTime.now();
  DateTime _endUploadDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        title: const Text('Sort and Filter Options'),
        content: SizedBox(
          width: double.maxFinite,
          height: 800,
          child: DraggableScrollableSheet(
            initialChildSize: 1,
            minChildSize: 1,
            maxChildSize: 1,
            builder: (BuildContext context, ScrollController scrollController) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sort By:',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DropdownButton<String>(
                      value: _selectedSortingOption,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSortingOption = newValue!;
                        });
                      },
                      items: <String>[
                        'Video Upload Date',
                        'Download Date',
                        'Title',
                        'Duration',
                        'Download Duration',
                        'Download Speed',
                        'File Size',
                        'Music Quality',
                        'Video URL',
                        'Enclosing Playlist',
                        'Audio Download DateTime',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    Row(
                      children: [
                        const Text('Sort Ascending:'),
                        Checkbox(
                          value: _sortAscending,
                          onChanged: (bool? newValue) {
                            setState(() {
                              _sortAscending = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    const Text(
                      'Filter Options:',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Audio Title Substring:'),
                    TextField(
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        hintText: '',
                        isDense:
                            true, // You can try adding isDense: true to better align the text vertically
                        contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        border: InputBorder.none,
                      ),
                      controller: _audioTitleSubStringController,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        _audioTitleSubString = value;
                      },
                    ),
                    Row(
                      children: [
                        const Text('Music Quality:'),
                        Checkbox(
                          value: _filterMusicQuality,
                          onChanged: (bool? newValue) {
                            setState(() {
                              _filterMusicQuality = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 120,
                          child: Text('Start downl date'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _startDownloadDateTime,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );

                            if (pickedDate != null) {
                              // Add this check
                              _startDownloadDateTime = pickedDate;
                              _startDownloadDateTimeController.text =
                                  DateFormat('dd-MM-yyyy')
                                      .format(_startDownloadDateTime);
                            }
                          },
                        ),
                        SizedBox(
                          width: 80,
                          child: TextField(
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              hintText: '',
                              isDense:
                                  true, // You can try adding isDense: true to better align the text vertically
                              contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                              border: InputBorder.none,
                            ),
                            controller: _startDownloadDateTimeController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 120,
                          child: Text('End downl date'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _endDownloadDateTime,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );

                            if (pickedDate != null) {
                              // Add this check
                              _endDownloadDateTime = pickedDate;
                              _endDownloadDateTimeController.text =
                                  DateFormat('dd-MM-yyyy')
                                      .format(_endDownloadDateTime);
                            }
                          },
                        ),
                        SizedBox(
                          width: 80,
                          child: TextField(
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              hintText: '',
                              isDense:
                                  true, // You can try adding isDense: true to better align the text vertically
                              contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                              border: InputBorder.none,
                            ),
                            controller: _endDownloadDateTimeController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 120,
                          child: Text('Start upl date'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _startUploadDateTime,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );

                            if (pickedDate != null) {
                              // Add this check
                              _startUploadDateTime = pickedDate;
                              _startUploadDateTimeController.text =
                                  DateFormat('dd-MM-yyyy')
                                      .format(_startUploadDateTime);
                            }
                          },
                        ),
                        SizedBox(
                          width: 80,
                          child: TextField(
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              hintText: '',
                              isDense:
                                  true, // You can try adding isDense: true to better align the text vertically
                              contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                              border: InputBorder.none,
                            ),
                            controller: _startUploadDateTimeController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 120,
                          child: Text('End downl date'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _endUploadDateTime,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );

                            if (pickedDate != null) {
                              // Add this check
                              _endUploadDateTime = pickedDate;
                              _endUploadDateTimeController.text =
                                  DateFormat('dd-MM-yyyy')
                                      .format(_endUploadDateTime);
                            }
                          },
                        ),
                        SizedBox(
                          width: 80,
                          child: TextField(
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              hintText: '',
                              isDense:
                                  true, // You can try adding isDense: true to better align the text vertically
                              contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                              border: InputBorder.none,
                            ),
                            controller: _endUploadDateTimeController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const Text('File Size Range (bytes):'),
                    Row(
                      children: [
                        const Text('Start:'),
                        SizedBox(
                          width: 50,
                          child: TextField(
                            controller: _startFileSizeController,
                            keyboardType: TextInputType.number,
                            maxLength: 9,
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Text('End:'),
                        SizedBox(
                          width: 50,
                          child: TextField(
                            controller: _endFileSizeController,
                            keyboardType: TextInputType.number,
                            maxLength: 9,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Apply sorting and filtering options
              print('Sorting option: $_selectedSortingOption');
              print('Sort ascending: $_sortAscending');
              print('Filter by music quality: $_filterMusicQuality');
              print('Audio title substring: $_audioTitleSubString');
              print(
                  'Start download date: ${_startDownloadDateTime.toIso8601String()}');
              print(
                  'End download date: ${_endDownloadDateTime.toIso8601String()}');
              print(
                  'Start upload date: ${_startUploadDateTime.toIso8601String()}');
              print('End upload date: ${_endUploadDateTime.toIso8601String()}');
              print(
                  'File size range: ${_startFileSizeController.text} - ${_endFileSizeController.text}');
              Navigator.of(context).pop();
            },
            child: const Text('Apply'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}
