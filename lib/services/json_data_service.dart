import 'dart:convert';
import 'dart:io';

import '../models/audio.dart';
import '../models/playlist.dart';

typedef FromJsonFunction<T> = T Function(Map<String, dynamic> jsonDataMap);
typedef ToJsonFunction<T> = Map<String, dynamic> Function(T model);

class ClassNotContainedInJsonFileException implements Exception {
  String _className;
  String _jsonFilePathName;
  StackTrace _stackTrace;

  ClassNotContainedInJsonFileException({
    required String className,
    required String jsonFilePathName,
    StackTrace? stackTrace,
  })  : _className = className,
        _jsonFilePathName = jsonFilePathName,
        _stackTrace = stackTrace ?? StackTrace.current;

  @override
  String toString() {
    return ('Class $_className not stored in $_jsonFilePathName file.\nStack Trace:\n$_stackTrace');
  }
}

class ClassNotSupportedByToJsonDataServiceException implements Exception {
  String _className;
  StackTrace _stackTrace;

  ClassNotSupportedByToJsonDataServiceException({
    required String className,
    StackTrace? stackTrace,
  })  : _className = className,
        _stackTrace = stackTrace ?? StackTrace.current;

  @override
  String toString() {
    return ('Class $_className has no entry in JsonDataService._toJsonFunctionsMap.\nStack Trace:\n$_stackTrace');
  }
}

class ClassNotSupportedByFromJsonDataServiceException implements Exception {
  String _className;
  StackTrace _stackTrace;

  ClassNotSupportedByFromJsonDataServiceException({
    required String className,
    StackTrace? stackTrace,
  })  : _className = className,
        _stackTrace = stackTrace ?? StackTrace.current;

  @override
  String toString() {
    return ('Class $_className has no entry in JsonDataService._fromJsonFunctionsMap.\nStack Trace:\n$_stackTrace');
  }
}

class JsonDataService {
  // typedef FromJsonFunction<T> = T Function(Map<String, dynamic> jsonDataMap);
  static final Map<Type, FromJsonFunction> _fromJsonFunctionsMap = {
    Audio: (jsonDataMap) => Audio.fromJson(jsonDataMap),
    Playlist: (jsonDataMap) => Playlist.fromJson(jsonDataMap),
  };

  // typedef ToJsonFunction<T> = Map<String, dynamic> Function(T model);
  static final Map<Type, ToJsonFunction> _toJsonFunctionsMap = {
    Audio: (model) => model.toJson(),
    Playlist: (model) => model.toJson(),
  };

  static void saveToFile({
    required dynamic model,
    required String path,
  }) {
    final String jsonStr = encodeJson(model);
    File(path).writeAsStringSync(jsonStr);
  }

  static dynamic loadFromFile({
    required String jsonPathfileName,
    required Type type,
  }) {
    if (File(jsonPathfileName).existsSync()) {
      final String jsonStr = File(jsonPathfileName).readAsStringSync();

      try {
        return decodeJson(jsonStr, type);
      } catch (e) {
        throw ClassNotContainedInJsonFileException(
          className: type.toString(),
          jsonFilePathName: jsonPathfileName,
        );
      }
    } else {
      return null;
    }
  }

  static String encodeJson(dynamic data) {
    if (data is List) {
      throw Exception(
          "encodeJson() does not support encoding list's. Use encodeJsonList() instead.");
    } else {
      final type = data.runtimeType;
      final toJsonFunction = _toJsonFunctionsMap[type];
      if (toJsonFunction != null) {
        return jsonEncode(toJsonFunction(data));
      }
    }

    return '';
  }

  static dynamic decodeJson(
    String jsonString,
    Type type,
  ) {
    final fromJsonFunction = _fromJsonFunctionsMap[type];

    if (fromJsonFunction != null) {
      final jsonData = jsonDecode(jsonString);
      if (jsonData is List) {
        throw Exception(
            "decodeJson() does not support decoding list's. Use decodeJsonList() instead.");
      } else {
        return fromJsonFunction(jsonData);
      }
    }

    return null;
  }

  static void saveListToFile({
    required String path,
    required dynamic data,
  }) {
    String jsonStr = encodeJsonList(data);
    File(path).writeAsStringSync(jsonStr);
  }

  static List<T> loadListFromFile<T>({
    required String path,
    required Type type,
  }) {
    if (File(path).existsSync()) {
      String jsonStr = File(path).readAsStringSync();

      try {
        return decodeJsonList(jsonStr, type);
      } on StateError {
        throw ClassNotContainedInJsonFileException(
          className: type.toString(),
          jsonFilePathName: path,
        );
      }
    } else {
      return [];
    }
  }

  static String encodeJsonList(dynamic data) {
    if (data is List) {
      if (data.isNotEmpty) {
        final type = data.first.runtimeType;
        final toJsonFunction = _toJsonFunctionsMap[type];
        if (toJsonFunction != null) {
          return jsonEncode(data.map((e) => toJsonFunction(e)).toList());
        } else {
          throw ClassNotSupportedByToJsonDataServiceException(
            className: type.toString(),
          );
        }
      }
    } else {
      throw Exception(
          "encodeJsonList() only supports encoding list's. Use encodeJson() instead.");
    }

    return '';
  }

  static List<T> decodeJsonList<T>(
    String jsonString,
    Type type,
  ) {
    final fromJsonFunction = _fromJsonFunctionsMap[type];

    if (fromJsonFunction != null) {
      final jsonData = jsonDecode(jsonString);
      if (jsonData is List) {
        if (jsonData.isNotEmpty) {
          final list = jsonData.map((e) => fromJsonFunction(e)).toList();
          return list.cast<T>(); // Cast the list to the desired type
        } else {
          return <T>[]; // Return an empty list of the desired type
        }
      } else {
        throw Exception(
            "decodeJsonList() only supports decoding list's. Use decodeJson() instead.");
      }
    } else {
      throw ClassNotSupportedByFromJsonDataServiceException(
        className: type.toString(),
      );
    }
  }

  /// print jsonStr in formatted way
  static void printJsonString({
    required String methodName,
    required String jsonStr,
  }) {
    String prettyJson =
        JsonEncoder.withIndent('  ').convert(json.decode(jsonStr));
    print('$methodName:\n$prettyJson');
  }
}
