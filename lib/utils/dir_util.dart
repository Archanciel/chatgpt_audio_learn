import 'dart:io';

import '../constants.dart';

class DirUtil {
  static String getPlaylistDownloadHomePath({bool isTest = false}) {
    if (Platform.isWindows) {
      if (isTest) {
        return kDownloadAppTestDirWindows;
      } else {
        return kDownloadAppDirWindows;
      }
    } else {
      if (isTest) {
        return kDownloadAppTestDir;
      } else {
        return kDownloadAppDir;
      }
    }
  }

  static Future<void> createAppDirIfNotExist({
    bool isAppDirToBeDeleted = false,
  }) async {
    String path = DirUtil.getPlaylistDownloadHomePath();
    final Directory directory = Directory(path);

    // using await directory.exists did delete dir only on second
    // app restart. Uncomprehensible !
    bool directoryExists = directory.existsSync();

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

  static Future<void> copyFileToDirectory({
    required String sourceFilePathName,
    required String targetDirectoryPath,
    String? targetFileName,
  }) async {
    File sourceFile = File(sourceFilePathName);
    String copiedFileName = targetFileName ?? sourceFile.uri.pathSegments.last;
    String targetFilePath = '$targetDirectoryPath/$copiedFileName';

    await sourceFile.copy(targetFilePath);
  }
}
