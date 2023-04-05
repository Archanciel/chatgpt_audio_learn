import 'package:intl/intl.dart';

const String kApplicationName = "ChatGPT Playlist Download";
const String kApplicationVersion = '0.1';
const String kDownloadAppDir = '/storage/emulated/0/Download/audio';
// not working: getDownloadedAudioNameLst() returns empty list !
//const String kDownloadAppDir = '/storage/9016-4EF8/Audio';
const String kDownloadAppDirWindows =
    'C:\\Users\\Jean-Pierre\\Downloads\\Audio';

// files in this local test dir are stored in project test_data dir updated
// on GitHub
const String kDownloadAppTestDir = "C:\\Users\\Jean-Pierre\\Development\\Flutter\\chatgpt_audio_learn\\test\\data\\audio";

const String kDefaultJsonFileName = 'circadian.json';
const double kVerticalFieldDistance = 23.0;
const double kVerticalFieldDistanceAddSubScreen = 1.0;
const double kResetButtonBottomDistance = 5.0;

DateFormat englishDateTimeFormat = DateFormat("yyyy-MM-dd HH:mm");
DateFormat frenchDateTimeFormat = DateFormat("dd-MM-yyyy HH:mm");

// to_delete playlist url
// const String kUniquePlaylistUrl =
//     'https://youtube.com/playlist?list=PLzwWSJNcZTMTB9iwbu77FGokc3WsoxuV0';
// const String kUniquePlaylistTitle = 'to_delete';
// const bool kDeleteAppDir = false;

// audio_learn_test_download_2_small_videos playlist url
const String kUniquePlaylistUrl =
    'https://youtube.com/playlist?list=PLzwWSJNcZTMRB9ILve6fEIS_OHGrV5R2o';
const String kUniquePlaylistTitle = 'audio_learn_test_download_2_small_videos';
const bool kDeleteAppDir = false;

// audio_learn playlist url
// const String kUniquePlaylistUrl =
//     'https://youtube.com/playlist?list=PLzwWSJNcZTMRBJuvE6vk6PMnqIBhCKUIa';
// const String kUniquePlaylistTitle = 'audio_learn';
// const bool kDeleteAppDir = false;

const double kAudioDefaultSpeed = 1.25;
const String kSecretClientCodeJsonFileName =
    'code_secret_client_923487935936-po8d733kjvrnee3l3ik3r5mebe8ebhr7.apps.googleusercontent.com.json';

const kGoogleApiKey = 'AIzaSyDhywmh5EKopsNsaszzMkLJ719aQa2NHBw';

/// A constant that is true if the application was compiled to run on the web.
const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');
