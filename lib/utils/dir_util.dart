import 'dart:io';

import '../constants.dart';

class DirUtil {
  static Future<String> getPlaylistDownloadHomePath(
      {bool isTest = false}) async {
    if (isTest) {
      return kDownloadAppTestDir;
    } else {
      return kDownloadAppDir;
    }
  }

  /// Async main method which instanciates and loads the
  /// TransferDataViewModel.
  static Future<void> createAppDirIfNotExist({
    bool isAppDirToBeDeleted = false,
  }) async {
    String path = kDownloadAppDir;
    final Directory directory = Directory(path);
    bool directoryExists = await directory.exists();

    if (isAppDirToBeDeleted) {
      if (directoryExists) {
        DirUtil.deleteFilesInDir(path);
      }
    }

    if (!directoryExists) {
      await directory.create();
    }
  }

  static Future<void> createDirIfNotExist({
    required String path,
  }) async {
    final Directory directory = Directory(path);
    bool directoryExists = await directory.exists();

    if (!directoryExists) {
      await directory.create(recursive: true);
    }
  }

  static void deleteFilesInDir(String transferDataJsonPath) {
    final Directory directory = Directory(transferDataJsonPath);
    final List<FileSystemEntity> contents = directory.listSync();

    for (FileSystemEntity file in contents) {
      file.deleteSync();
    }
  }
}
