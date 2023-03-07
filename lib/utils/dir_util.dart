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

  static Future<void> createAppDirIfNotExist({
    bool isAppDirToBeDeleted = false,
  }) async {
    String path = kDownloadAppDir;
    final Directory directory = Directory(path);
    bool directoryExists = await directory.exists();

    if (isAppDirToBeDeleted) {
      if (directoryExists) {
        DirUtil.deleteFilesInDirAndSubDirs(path);
      }
    }

    if (!directoryExists) {
      await directory.create();
    }
  }

  static Future<void> createDirIfNotExist({
    required String pathStr,
  }) async {
    final Directory directory = Directory(pathStr);
    bool directoryExists = await directory.exists();

    if (!directoryExists) {
      await directory.create(recursive: true);
    }
  }

  static void deleteFilesInDirAndSubDirs(String transferDataJsonPath) {
    final Directory directory = Directory(transferDataJsonPath);
    final List<FileSystemEntity> contents = directory.listSync(recursive: true);

    for (FileSystemEntity file in contents) {
      if (file is File) {
        file.deleteSync();
      }
    }
  }
}
