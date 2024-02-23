import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  late SortingOption _selectedSortingOption =
      SortingOption.audioDownloadDateTime;
  late bool _sortAscending = true;
  List<SortingOption> _selectedOptions =
      []; // New list to store selected options

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add source list items to target list'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<SortingOption>(
            value: _selectedSortingOption,
            onChanged: (SortingOption? newValue) {
              if (newValue != null && !_selectedOptions.contains(newValue)) {
                setState(() {
                  _selectedOptions
                      .add(newValue); // Add the selected item to the list
                });
              }
            },
            items: SortingOption.values
                .map<DropdownMenuItem<SortingOption>>((SortingOption value) {
              return DropdownMenuItem<SortingOption>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          // Display selected options as chips
          ListView.builder(
            shrinkWrap:
                true, // Use it inside a Column to prevent infinite height error
            physics:
                NeverScrollableScrollPhysics(), // Disables scrolling within the ListView
            itemCount: _selectedOptions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                    _sortingOptionToString(_selectedOptions[index], context)),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _selectedOptions
                          .removeAt(index); // Remove the option from the list
                    });
                  },
                ),
              );
            },
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
          ElevatedButton(
            onPressed: () => _showSetSortParametersDialog(),
            child: const Text('Open Lists Dialog'),
          ),
        ],
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

  void _showSetSortParametersDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Use StatefulBuilder to create a local state for the dialog
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Set Sort Parameters'),
              content: SizedBox(
                // Required to solve the error RenderBox was
                // not laid out: RenderPhysicalShape#ee087 relayoutBoundary=up2
                // 'package:flutter/src/rendering/box.dart':
                //
                // Enclodsing ListView inside a SizedBox widget
                // does not solve the error since the ListView is
                // in a column contained in a Dialog widget.
                width: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DropdownButton<SortingOption>(
                      value: _selectedSortingOption,
                      onChanged: (SortingOption? newValue) {
                        if (newValue != null &&
                            !_selectedOptions.contains(newValue)) {
                          setState(() {
                            _selectedOptions.add(
                                newValue); // Add the selected item to the list
                          });
                        }
                      },
                      items: SortingOption.values
                          .map<DropdownMenuItem<SortingOption>>(
                              (SortingOption value) {
                        return DropdownMenuItem<SortingOption>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                    ),
                    // Display selected options as chips
                    ListView.builder(
                      shrinkWrap:
                          true, // Use it inside a Column to prevent infinite height error
                      physics:
                          NeverScrollableScrollPhysics(), // Disables scrolling within the ListView
                      itemCount: _selectedOptions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_sortingOptionToString(
                              _selectedOptions[index], context)),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                _selectedOptions.removeAt(
                                    index); // Remove the option from the list
                              });
                            },
                          ),
                        );
                      },
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
                  ],
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
