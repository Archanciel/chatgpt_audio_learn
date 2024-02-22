import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class Audio {
  static DateFormat downloadDatePrefixFormatter = DateFormat('yyMMdd');
  static DateFormat downloadDateTimePrefixFormatter =
      DateFormat('yyMMdd-HHmmss');
  static DateFormat uploadDateSuffixFormatter = DateFormat('yy-MM-dd');

  // Video title displayed on Youtube
  final String originalVideoTitle = '';

  // Video title which does not contain invalid characters which
  // would cause the audio file name to genertate an file creation
  // exception
  String validVideoTitle = '';

  String compactVideoDescription = '';

  // Url referencing the video from which rhe audio was extracted
  final String videoUrl = '';

  // Audio download date time
  final DateTime audioDownloadDateTime = DateTime.now();

  // Duration in which the audio was downloaded
  Duration? audioDownloadDuration;

  // Date at which the video containing the audio was added on
  // Youtube
  final DateTime videoUploadDate = DateTime.now();

  // Stored audio file name
  String audioFileName = '';

  // Duration of downloaded audio
  final Duration? audioDuration = Duration.zero;

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

  // true if the audio is currently playing or if it is paused
  // with its position between 0 and its total duration.
  bool isPlayingOrPausedWithPositionBetweenAudioStartAndEnd = false;
  int audioPositionSeconds = 0;

  bool isPaused = true;

  // Usefull in order to reduce the next play position according
  // to the value of the duration between the time the audio was
  // paused and the time the audio was played again.
  //
  // For example, if the audio was paused for less than 1 minute,
  // the next play position will be reduced by 2 seconds.
  // If the audio was paused for more than 1 minute and less than
  // 1 hour, the next play position will be reduced by 20 seconds.
  // If the audio was paused for more than 1 hour, the next play
  // position will be reduced by 30 seconds.
  DateTime? audioPausedDateTime;

  double audioPlaySpeed = 1;
  double audioPlayVolume = 1;

  bool isAudioMusicQuality = false;
  bool get isMusicQuality => isAudioMusicQuality;
  set isMusicQuality(bool isMusicQuality) {
    isAudioMusicQuality = isMusicQuality;
    audioPlaySpeed = (isMusicQuality) ? 1.0 : 1;
  }
}

enum SortingOption {
  audioDownloadDateTime,
  videoUploadDate,
  validAudioTitle,
  audioEnclosingPlaylistTitle,
  audioDuration,
  audioFileSize,
  audioMusicQuality,
  audioDownloadSpeed,
  audioDownloadDuration,
  videoUrl, // useful to detect audio duplicates
}

class AudioSortFilterService {
  static Map<SortingOption, bool> sortingOptionToAscendingMap = {
    SortingOption.audioDownloadDateTime: false,
    SortingOption.videoUploadDate: false,
    SortingOption.validAudioTitle: true,
    SortingOption.audioEnclosingPlaylistTitle: true,
    SortingOption.audioDuration: false,
    SortingOption.audioFileSize: false,
    SortingOption.audioMusicQuality: false,
    SortingOption.audioDownloadSpeed: false,
    SortingOption.audioDownloadDuration: false,
    SortingOption.videoUrl: true,
  };

  /// This method is used to sort the audio list by the given sorting
  /// option. It is public only in order to be tested.
  List<Audio> sortAudioLstBySortingOption({
    required List<Audio> audioLst,
    required SortingOption sortingOption,
    bool asc = true,
  }) {
    switch (sortingOption) {
      case SortingOption.audioDownloadDateTime:
        return _sortAudioLstByAudioDownloadDateTime(
          audioLst: audioLst,
          asc: asc,
        );
      case SortingOption.videoUploadDate:
        return _sortAudioLstByVideoUploadDate(
          audioLst: audioLst,
          asc: asc,
        );
      case SortingOption.validAudioTitle:
        return _sortAudioLstByTitle(
          audioLst: audioLst,
          asc: asc,
        );
      case SortingOption.audioDuration:
        return _sortAudioLstByDuration(
          audioLst: audioLst,
          asc: asc,
        );
      case SortingOption.audioFileSize:
        return _sortAudioLstByFileSize(
          audioLst: audioLst,
          asc: asc,
        );
      case SortingOption.audioMusicQuality:
        return _sortAudioLstByMusicQuality(
          audioLst: audioLst,
          asc: asc,
        );
      case SortingOption.audioDownloadSpeed:
        return _sortAudioLstByDownloadSpeed(
          audioLst: audioLst,
          asc: asc,
        );
      case SortingOption.audioDownloadDuration:
        return _sortAudioLstByDownloadDuration(
          audioLst: audioLst,
          asc: asc,
        );
      case SortingOption.videoUrl:
        return _sortAudioLstByVideoUrl(
          audioLst: audioLst,
          asc: asc,
        );
      default:
        return audioLst;
    }
  }

  List<Audio> _sortAudioLstByVideoUploadDate({
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

  List<Audio> _sortAudioLstByAudioDownloadDateTime({
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

  /// Does not sort 'Échapper title' and 'ÉPICURE
  /// title' correctly !
  List<Audio> _sortAudioLstByTitle({
    required List<Audio> audioLst,
    bool asc = true,
  }) {
    if (asc) {
      audioLst.sort((a, b) {
        String cleanA = a.validVideoTitle
            .replaceAll(RegExp(r'[^A-Za-z0-9éèêëîïôœùûüÿç]'), '');
        String cleanB = b.validVideoTitle
            .replaceAll(RegExp(r'[^A-Za-z0-9éèêëîïôœùûüÿç]'), '');
        return cleanA.compareTo(cleanB);
      });
    } else {
      audioLst.sort((a, b) {
        String cleanA = a.validVideoTitle
            .replaceAll(RegExp(r'[^A-Za-z0-9éèêëîïôœùûüÿç]'), '');
        String cleanB = b.validVideoTitle
            .replaceAll(RegExp(r'[^A-Za-z0-9éèêëîïôœùûüÿç]'), '');
        return cleanB.compareTo(cleanA);
      });
    }

    return audioLst;
  }

  List<Audio> _sortAudioLstByDuration({
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

  List<Audio> _sortAudioLstByDownloadDuration({
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

  List<Audio> _sortAudioLstByDownloadSpeed({
    required List<Audio> audioLst,
    required bool asc,
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
          return 1;
        } else if (a.audioDownloadSpeed > b.audioDownloadSpeed) {
          return -1;
        } else {
          return 0;
        }
      });
    }

    return audioLst;
  }

  List<Audio> _sortAudioLstByFileSize({
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

  List<Audio> _sortAudioLstByMusicQuality({
    required List<Audio> audioLst,
    bool asc = true,
  }) {
    List<Audio> sortedAudioList = [];
    List<Audio> musicQualityList = [];
    List<Audio> speechQualityList = [];

    for (Audio audio in audioLst) {
      if (audio.isMusicQuality) {
        musicQualityList.add(audio);
      } else {
        speechQualityList.add(audio);
      }
    }

    if (asc) {
      sortedAudioList = musicQualityList + speechQualityList;
    } else {
      sortedAudioList = speechQualityList + musicQualityList;
    }

    return sortedAudioList;
  }

  List<Audio> _sortAudioLstByVideoUrl({
    required List<Audio> audioLst,
    bool asc = true,
  }) {
    if (asc) {
      audioLst.sort((a, b) {
        return a.videoUrl.compareTo(b.videoUrl);
      });
    } else {
      audioLst.sort((a, b) {
        return b.videoUrl.compareTo(a.videoUrl);
      });
    }

    return audioLst;
  }

  List<Audio> filterAndSortAudioLst({
    required List<Audio> audioLst,
    required SortingOption sortingOption,
    String? searchWords,
    bool ignoreCase = false,
    bool searchInVideoCompactDescription = false,
    bool asc = true,
  }) {
    if (searchWords != null && searchWords.isNotEmpty) {
      if (!searchInVideoCompactDescription) {
        audioLst = _filterAudioLstByVideoTitleOnly(
          audioLst: audioLst,
          searchWords: searchWords,
          ignoreCase: ignoreCase,
        );
      } else {
        audioLst = _filterAudioLstByVideoTitleOrDescription(
          audioLst: audioLst,
          searchWords: searchWords,
          ignoreCase: ignoreCase,
        );
      }
    }

    return sortAudioLstBySortingOption(
      audioLst: audioLst,
      sortingOption: sortingOption,
      asc: asc,
    );
  }

  List<Audio> _filterAudioLstByVideoTitleOnly({
    required List<Audio> audioLst,
    required String searchWords,
    required bool ignoreCase,
  }) {
    RegExp searchWordsPattern = RegExp(searchWords, caseSensitive: !ignoreCase);

    return audioLst.where((audio) {
      return searchWordsPattern.hasMatch(audio.validVideoTitle);
    }).toList();
  }

  List<Audio> _filterAudioLstByVideoTitleOrDescription({
    required List<Audio> audioLst,
    required String searchWords,
    required bool ignoreCase,
  }) {
    RegExp searchWordsPattern = RegExp(searchWords, caseSensitive: !ignoreCase);

    return audioLst.where((audio) {
      return searchWordsPattern.hasMatch(
          '${audio.validVideoTitle} ${audio.compactVideoDescription}');
    }).toList();
  }

  List<Audio> _filterAudioLstByAudioDownloadDateTime({
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

  List<Audio> _filterAudioLstByAudioVideoUploadDateTime({
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

  List<Audio> _filterAudioLstByAudioFileSize({
    required List<Audio> audioLst,
    required int startFileSize,
    required int endFileSize,
  }) {
    return audioLst.where((audio) {
      return (audio.audioFileSize >= startFileSize) &&
          (audio.audioFileSize <= endFileSize);
    }).toList();
  }

  List<Audio> _filterAudioLstByMusicQuality({
    required List<Audio> audioLst,
    required bool isMusicQuality,
  }) {
    return audioLst.where((audio) {
      return audio.isMusicQuality == isMusicQuality;
    }).toList();
  }

  List<Audio> _filterAudioByAudioDuration({
    required List<Audio> audioLst,
    required Duration startDuration,
    required Duration endDuration,
  }) {
    return audioLst.where((audio) {
      return (audio.audioDownloadDuration!.inMilliseconds >=
              startDuration.inMilliseconds) &&
          (audio.audioDownloadDuration!.inMilliseconds <=
              endDuration.inMilliseconds);
    }).toList();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SourceTargetListsVM(),
      child: const MaterialApp(
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SortingOption _selectedSortingOption = SortingOption.audioDownloadDateTime;
  late bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    SourceTargetListsVM sourceTargetListsVMListenFalse =
        Provider.of<SourceTargetListsVM>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add source list items to target list'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showReorderDialog(
            context,
            sourceTargetListsVMListenFalse,
          ),
          child: const Text('Open Lists Dialog'),
        ),
      ),
    );
  }

  String _sortingOptionToString(
    SortingOption option,
    BuildContext context,
  ) {
    switch (option) {
      case SortingOption.audioDownloadDateTime:
        return 'audioDownloadDateTime';
      case SortingOption.videoUploadDate:
        return 'videoUploadDate';
      case SortingOption.validAudioTitle:
        return 'validVideoTitleLabel';
      case SortingOption.audioEnclosingPlaylistTitle:
        return 'audioEnclosingPlaylistTitle';
      case SortingOption.audioDuration:
        return 'audioDuration';
      case SortingOption.audioFileSize:
        return 'audioFileSize';
      case SortingOption.audioMusicQuality:
        return 'audioMusicQuality';
      case SortingOption.audioDownloadSpeed:
        return 'audioDownloadSpeed';
      case SortingOption.audioDownloadDuration:
        return 'audioDownloadDuration';
      case SortingOption.videoUrl:
        return 'videoUrlLabel';
      default:
        throw ArgumentError('Invalid sorting option');
    }
  }

  void _showReorderDialog(
    BuildContext context,
    SourceTargetListsVM sourceTargetListsVMListenFalse,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('List Items To List Dialog'),
          content: SizedBox(
            width: double.maxFinite,
            height: 800,
            child: DraggableScrollableSheet(
              initialChildSize: 1,
              minChildSize: 1,
              maxChildSize: 1,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'sortBy',
                      ),
                      DropdownButton<SortingOption>(
                        key: const Key('sortingOptionDropdownButton'),
                        value: _selectedSortingOption,
                        onChanged: (SortingOption? newValue) {
                          setState(() {
                            _selectedSortingOption = newValue!;
                            _sortAscending = AudioSortFilterService
                                .sortingOptionToAscendingMap[newValue]!;
                          });
                        },
                        items: SortingOption.values
                            .map<DropdownMenuItem<SortingOption>>(
                                (SortingOption value) {
                          return DropdownMenuItem<SortingOption>(
                            value: value,
                            child: Text(_sortingOptionToString(value, context)),
                          );
                        }).toList(),
                      ),
                      Row(
                        children: [
                          ChoiceChip(
                            // The Flutter ChoiceChip widget is designed
                            // to represent a single choice from a set of
                            // options.
                            key: const Key('sortAscending'),
                            label: Text('sortAscending'),
                            selected: _sortAscending,
                            onSelected: (bool selected) {
                              setState(() {
                                _sortAscending = selected;
                              });
                            },
                          ),
                          ChoiceChip(
                            // The Flutter ChoiceChip widget is designed
                            // to represent a single choice from a set of
                            // options.
                            key: const Key('sortDescending'),
                            label: Text('sortDescending'),
                            selected: !_sortAscending,
                            onSelected: (bool selected) {
                              setState(() {
                                _sortAscending = !selected;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDraggableList(
    SourceTargetListsVM sourceTargetListsVM,
    bool isListOne,
  ) {
    return ListView.builder(
      itemCount: sourceTargetListsVM.sourceList.length,
      itemBuilder: (context, index) {
        return Draggable<String>(
          // enables dragging list items
          data: sourceTargetListsVM.sourceList[index],
          feedback: Material(
            elevation: 4.0,
            child: Container(
              width: 100,
              height: 56,
              color: Colors.blue,
              child: Center(
                child: Text(
                  sourceTargetListsVM.sourceList[index],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          childWhenDragging: Container(),
          onDragCompleted: () {},
          child: ListTile(
            title: Text(sourceTargetListsVM.sourceList[index]),
          ),
        );
      },
    );
  }

  Widget _buildDragTargetList(
    SourceTargetListsVM sourceTargetListsVMListenFalse,
    bool isListOne,
  ) {
    return Consumer<SourceTargetListsVM>(
      builder: (context, sourceTargetListsVMConsumer, child) {
        return DragTarget<String>(
          // enables receiving dragged list items
          onWillAccept: (data) => true,
          onAccept: (data) {
            if (!sourceTargetListsVMListenFalse.targetList.contains(data)) {
              sourceTargetListsVMListenFalse.addToTargetList(data);
            }
          },
          builder: (context, candidateData, rejectedData) {
            return ListView.builder(
              itemCount: sourceTargetListsVMListenFalse.targetList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(sourceTargetListsVMListenFalse.targetList[index]),
                  trailing: IconButton(
                    onPressed: () {
                      sourceTargetListsVMConsumer.removeFromTargetListAt(index);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class SourceTargetListsVM extends ChangeNotifier {
  final List<String> _sourceList;
  List<String> get sourceList => _sourceList;

  final List<String> _targetList;
  List<String> get targetList => _targetList;

  SourceTargetListsVM()
      : _sourceList = [
          'Item 1',
          'Item 2',
          'Item 3',
        ],
        _targetList = [
          'Item A',
          'Item B',
          'Item C',
        ];

  void addToTargetList(String item) {
    _targetList.add(item);

    notifyListeners();
  }

  void removeFromTargetListAt(int index) {
    _targetList.removeAt(index);

    notifyListeners();
  }
}
