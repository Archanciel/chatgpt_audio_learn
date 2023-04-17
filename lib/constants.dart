import 'package:intl/intl.dart';

const String kApplicationName = "ChatGPT Playlist Download";
const String kApplicationVersion = '0.1';
const String kDownloadAppDir = '/storage/emulated/0/Download/audio';
// not working: getDownloadedAudioNameLst() returns empty list !
//const String kDownloadAppDir = '/storage/9016-4EF8/Audio';

const String kDownloadAppDirWindows =
    'C:\\Users\\Jean-Pierre\\Downloads\\Audio';
    
// Tests are run on Windows only. Files in this local test dir are stored in project test_data dir updated
// on GitHub
const String kDownloadAppTestDir =
    "C:\\Users\\Jean-Pierre\\Development\\Flutter\\chatgpt_audio_learn\\test\\data\\audio";

// to_delete
// const String kUniquePlaylistUrl =
//     'https://youtube.com/playlist?list=PLzwWSJNcZTMTB9iwbu77FGokc3WsoxuV0';
// const String recreated_playlist_url =
//     "https://youtube.com/playlist?list=PLzwWSJNcZTMQp-I5fnRlCUY3ig7VY5Ihi";
// const String kUniquePlaylistUrl =
    // "https://youtube.com/playlist?list=PLzwWSJNcZTMQp-I5fnRlCUY3ig7VY5Ihi";

// This constant must be available in order for AudioDownloaderVM to
// be able to load the unique playlist json file.
// const String kUniquePlaylistTitle = 'to_delete';
// const bool kDeleteAppDir = false;

// files in this local test dir are stored in project test_data dir updated
// on GitHub
const String kDownloadAppTestDirWindows = "C:\\Users\\Jean-Pierre\\Development\\Flutter\\chatgpt_audio_learn\\test\\data\\audio";
// const bool kDeleteAppDir = false;

// audio_learn
const String kUniquePlaylistUrl =
    'https://youtube.com/playlist?list=PLzwWSJNcZTMRBJuvE6vk6PMnqIBhCKUIa';
//
// This constant must be available in order for AudioDownloaderVM to
// be able to load the unique playlist json file.
const String kUniquePlaylistTitle = 'audio_learn';
const bool kDeleteAppDir = false;

const double kAudioDefaultSpeed = 1.25;

const String kSecretClientCodeJsonFileName =
    'code_secret_client_923487935936-po8d733kjvrnee3l3ik3r5mebe8ebhr7.apps.googleusercontent.com.json';

const kGoogleApiKey = 'AIzaSyDhywmh5EKopsNsaszzMkLJ719aQa2NHBw';

/// A constant that is true if the application was compiled to run on
/// the web. Its value determines if requesting storage permission must
/// be performed.
const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');

const double kVerticalFieldDistance = 23.0;
const double kVerticalFieldDistanceAddSubScreen = 1.0;
const double kResetButtonBottomDistance = 5.0;

DateFormat englishDateTimeFormat = DateFormat("yyyy-MM-dd HH:mm");
DateFormat frenchDateTimeFormat = DateFormat("dd-MM-yyyy HH:mm");
