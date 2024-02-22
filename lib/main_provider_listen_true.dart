// https://chat.openai.com/share/52cb40eb-cd63-4720-8cd0-0a3152b9cd29

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class CounterViewModel extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;

    notifyListeners(); // Cela va notifier tous les listeners que quelque chose a changé
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CounterViewModel(),
      child: MaterialApp(
        home: CounterDisplay(),
      ),
    );
  }
}

class CounterDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counterProviderTrue = Provider.of<CounterViewModel>(context,
        listen: true); // S'abonne aux changements

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${counterProviderTrue.count}',
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            Provider.of<CounterViewModel>(context, listen: false)
                .increment(); // Ne nécessite pas de reconstruire ce widget
          },
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
