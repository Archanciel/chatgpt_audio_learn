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
                    child: Tooltip(
                      message: tooltipNotifier.message,
                      child: Icon(Icons.info),
                      preferBelow: false,
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

/* En fait, ToolTip n'est pas adapté à ce que je souhaite: lorsque je clicke sur le bouton dans cet exemple, le ToolTipNotifier est correctment utilisé. Mais je veux que le message s'affiche immédiatement au-dessus de l'icône, et pas seulement après que j'aie appuyé longuement sur l'icône.
*/