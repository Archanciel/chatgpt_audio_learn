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
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

/// Simplest possible model, with just one field.
///
/// [ChangeNotifier] is a class in `flutter:foundation`. [Counter] does
/// _not_ depend on Provider.
class Counter with ChangeNotifier {
  int value = 0;

  void increment() {
    value += 1;
    notifyListeners();
  }

  void decrement() {
    value -= 1;
    notifyListeners();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            // Consumer looks for an ancestor Provider widget
            // and retrieves its model (Counter, in this case).
            // Then it uses that model to build widgets, and will trigger
            // rebuilds if the model is updated.
            Consumer<Counter>(
              builder: (context, counter, child) => Column(
                children: [
                  Text(
                    '${counter.value}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  // Since this custom button is inside
                  // Consumer, it is rebuilt each time th
                  // Counter model calls notifyListeners()
                  CustomFloatingActionButton(
                    isMinus: false,
                    isInsideConsumer: true,
                  ),
                ],
              ),
            ),
            // Since this custom button is not inside
            // Consumer, it is not rebuilt each time the
            // Counter model calls notifyListeners()
            CustomFloatingActionButton(
              isMinus: false,
              isInsideConsumer: false,
            ),
          ],
        ),
      ),
      // Since this custom button is not inside Consumer, it
      // is not rebuilt each time the Counter model calls
      // notifyListeners()
      floatingActionButton: CustomFloatingActionButton(
        isMinus: true,
        isInsideConsumer: false,
      ),
    );
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  bool isMinus;
  bool isInsideConsumer;
  CustomFloatingActionButton({super.key, 
    required this.isMinus,
    this.isInsideConsumer = false,
  });

  @override
  Widget build(BuildContext context) {
    print(
        'CustomFloatingActionButton ${(isInsideConsumer) ? 'inside' : 'outside'} ${(isMinus) ? 'minus' : 'plus'} rebuilt !');

    return FloatingActionButton(
      onPressed: () {
        // You can access your providers anywhere you have access
        // to the context. One way is to use Provider.of<Counter>(context).
        //
        // The provider package also defines extension methods on context
        // itself. You can call context.watch<Counter>() in a build method
        // of any widget to access the current state of Counter, and to ask
        // Flutter to rebuild your widget anytime Counter changes.
        //
        // You can't use context.watch() outside build methods, because that
        // often leads to subtle bugs. Instead, you should use
        // context.read<Counter>(), which gets the current state
        // but doesn't ask Flutter for future rebuilds.
        //
        // Since we're in a callback that will be called whenever the user
        // taps the FloatingActionButton, we are not in the build method here.
        // We should use context.read().
        var counter = context.read<Counter>();

        if (isMinus) {
          counter.decrement();
        } else {
          counter.increment();
        }
      },
      tooltip: (isMinus) ? 'Decrement' : 'Increment',
      child: Icon((isMinus) ? Icons.remove : Icons.add),
    );
  }
}
