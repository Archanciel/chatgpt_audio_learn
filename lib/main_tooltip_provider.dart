import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TooltipNotifier(),
      child: MyApp(),
    ),
  );
}

class TooltipNotifier extends ChangeNotifier {
  bool _shouldShowTooltip = false;
  String _message = '';

  bool get shouldShowTooltip => _shouldShowTooltip;
  String get message => _message;

  void showTooltip(String message) {
    _shouldShowTooltip = true;
    _message = message;
    notifyListeners();
  }

  void hideTooltip() {
    _shouldShowTooltip = false;
    _message = '';
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Exemple de Tooltip avec Provider'),
        ),
        body: Consumer<TooltipNotifier>(
          builder: (context, tooltipNotifier, child) {
            return Stack(
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      tooltipNotifier.showTooltip('Message depuis le Provider');
                    },
                    child: Text('Afficher le Tooltip'),
                  ),
                ),
                if (tooltipNotifier.shouldShowTooltip)
                  Positioned(
                    top: 100,
                    left: 100,
                    child: CustomTooltip(
                      message: tooltipNotifier.message,
                      onClose: tooltipNotifier.hideTooltip,
                      child: Icon(Icons.info),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CustomTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final VoidCallback onClose;

  const CustomTooltip({
    Key? key,
    required this.message,
    required this.child,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onClose,
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(message),
                  ),
                ),
                child,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
