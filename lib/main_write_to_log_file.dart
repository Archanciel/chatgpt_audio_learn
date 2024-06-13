import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Log to File Example')),
        body: const Center(child: LogButton()),
      ),
    );
  }
}

class LogButton extends StatelessWidget {
  const LogButton({super.key});

  Future<void> writeToLogFile(String logMessage) async {
    try {
      // Get the directory for storing files.
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final file = File('$path/log.txt');

      // Write the log message to the file.
      await file.writeAsString('$logMessage\n', mode: FileMode.append, flush: true);
    } catch (e) {
      print('Error writing to log file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        writeToLogFile('Button pressed at ${DateTime.now()}');
      },
      child: const Text('Press to Log'),
    );
  }
}
