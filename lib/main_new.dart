import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: IconSwitcher());
  }
}

class IconSwitcher extends StatefulWidget {
  const IconSwitcher({super.key});

  @override
  _IconSwitcherState createState() => _IconSwitcherState();
}

class _IconSwitcherState extends State<IconSwitcher> {
  int _iconIndex = 0;

  List<Widget> _icons = [];

  @override
  void initState() {
    _icons = [
      IconButton(
        icon: ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.blue, // Desired color
              BlendMode.multiply, // Blend mode
            ),
            child: Image.asset(
              "assets/images/volume-0.png",
            )),
        iconSize: 36,
        onPressed: () => _updateIcon(index: 1),
      ),
      IconButton(
        icon: Image.asset("assets/images/volume_1.png"),
        iconSize: 36,
        onPressed: () => _updateIcon(index: 2),
      ),
      IconButton(
        icon: Image.asset("assets/images/volume_2.png"),
        iconSize: 36,
        onPressed: () => _updateIcon(index: 3),
      ),
      IconButton(
        icon: Image.asset("assets/images/icon-48.png"),
        iconSize: 36,
        onPressed: () => _updateIcon(index: 4),
      ),
      IconButton(
        icon: Image.asset("assets/images/icon-512.png"),
        iconSize: 36,
        onPressed: () => _updateIcon(index: 0),
      ),
    ];
    super.initState();
  }

  void _updateIcon({int index = 0}) {
    setState(() {
      _iconIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedSwitcher Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: _icons[_iconIndex],
            ),
          ],
        ),
      ),
    );
  }
}
