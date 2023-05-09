// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This basic application demonstrates how to use Provider to
/// rebuild only one widget when the counter value changes.
void main() {
  runApp(
    // Provide the model to all widgets within the app. We're using
    // ChangeNotifierProvider because that's a simple way to rebuild
    // widgets when a model changes. We could also just use
    // Provider, but then we would have to listen to Counter ourselves.
    //
    // Read Provider's docs to learn about all the available providers.
    ChangeNotifierProvider(
      // Initialize the model in the builder. That way, Provider
      // can own Counter's lifecycle, making sure to call `dispose`
      // when not needed anymore.
      create: (context) => WarningMessageVM(),
      child: const MyApp(),
    ),
  );
}

enum WarningMessageType {
  none,
  errorMessage,
  updatePlayListTitle,
}

class WarningMessageVM extends ChangeNotifier {
  WarningMessageType _warningMessageType = WarningMessageType.none;
  WarningMessageType get warningMessageType => _warningMessageType;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  set errorMessage(String errorMessage) {
    _errorMessage = errorMessage;

    if (errorMessage.isNotEmpty) {
      _warningMessageType = WarningMessageType.errorMessage;

      notifyListeners();
    }
  }

  String _updatedPlaylistTitle = '';
  String get updatedPlaylistTitle => _updatedPlaylistTitle;
  set updatedPlaylistTitle(String updatedPlaylistTitle) {
    _updatedPlaylistTitle = updatedPlaylistTitle;

    if (updatedPlaylistTitle.isNotEmpty) {
      _warningMessageType = WarningMessageType.updatePlayListTitle;

      notifyListeners();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    WarningMessageVM warningMessageVM = Provider.of<WarningMessageVM>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Consumer looks for an ancestor Provider widget
            // and retrieves its model (WarningMessageVM, in this case).
            // Then it uses that model to build widgets, and will trigger
            // rebuilds if the model is updated.
            Consumer<WarningMessageVM>(
              builder: (context, warningMessageVM, child) {
                WarningMessageType warningMessageType =
                    warningMessageVM.warningMessageType;

                switch (warningMessageType) {
                  case WarningMessageType.updatePlayListTitle:
                    String updatedPlayListTitle =
                        warningMessageVM.updatedPlaylistTitle;


                    if (updatedPlayListTitle.isNotEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                      displayWarningDialog(
                          context, 'Updated playlist: $updatedPlayListTitle');
                      });
                    }
                    return const SizedBox.shrink();
                  case WarningMessageType.errorMessage:
                    String errorMessage = warningMessageVM.errorMessage;
                    if (errorMessage.isNotEmpty) {
                        displayWarningDialog(
                            context, 'Error message: $errorMessage');
                    }

                    return const SizedBox.shrink();
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
            // Since those custom buttons are not inside
            // Consumer, they are not rebuilt each time the
            // Counter model calls notifyListeners()
            CustomFloatingActionButton(
              isUpdate: true,
              warningMessageVM: warningMessageVM,
            ),
            const SizedBox(height: 10),
            CustomFloatingActionButton(
              isUpdate: false,
              warningMessageVM: warningMessageVM,
            ),
          ],
        ),
      ),
    );
  }

  void displayWarningDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('WARNING'),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 13,
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  final bool isUpdate;
  final WarningMessageVM warningMessageVM;
  const CustomFloatingActionButton({super.key, 
    required this.isUpdate,
    required this.warningMessageVM,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (isUpdate) {
          warningMessageVM.updatedPlaylistTitle = 'Updated playlist title';
        } else {
          warningMessageVM.errorMessage = 'Error message';
        }
      },
      child: Icon((isUpdate) ? Icons.update : Icons.error),
    );
  }
}
