import 'package:intl/intl.dart';

const String kApplicationName = "ChatGPT Playlist Download";
const String kApplicationVersion = '0.1';
const String kDownloadAppDir = '/storage/emulated/0/Download/audio';

// files in this local test dir are stored in project test_data dir updated
// on GitHub
const String kDownloadAppTestDir = 'c:\\temp\\test\\audio';

const String kDefaultJsonFileName = 'circadian.json';
const double kVerticalFieldDistance = 23.0;
const double kVerticalFieldDistanceAddSubScreen = 1.0;
const double kResetButtonBottomDistance = 5.0;

DateFormat englishDateTimeFormat = DateFormat("yyyy-MM-dd HH:mm");
DateFormat frenchDateTimeFormat = DateFormat("dd-MM-yyyy HH:mm");
