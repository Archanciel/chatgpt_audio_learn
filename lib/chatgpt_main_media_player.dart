import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const MediaPlayerView(),
    );
  }
}

class MediaPlayerView extends StatefulWidget {
  const MediaPlayerView({super.key});

  @override
  State<MediaPlayerView> createState() => _MediaPlayerViewState();
}

class _MediaPlayerViewState extends State<MediaPlayerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bluetooth_audio),
            onPressed: () {},
          ),
          const SizedBox(width: 20),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Various',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Center(
              child: IconButton(
                icon: const Icon(Icons.play_arrow, size: 70),
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('0:43'),
                Expanded(
                  child: Slider(
                    value: 0.43,
                    onChanged: (value) {},
                    min: 0,
                    max: 2.55,
                  ),
                ),
                const Text('2:55:12'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, size: 40),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.replay_10, size: 40),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.pause, size: 60),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.forward_10, size: 40),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, size: 40),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              '🍁 Effondrement Historique de l\'Empire CHINOIS – Maintenant Evergrande ne sera pas Sauvé ! 2021-11-17.mp3',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.shuffle, color: Colors.grey),
              onPressed: () {},
            ),
            label: '1m',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.replay_10, color: Colors.grey),
              onPressed: () {},
            ),
            label: '10s',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.play_arrow, color: Colors.white),
              onPressed: () {},
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.forward_10, color: Colors.grey),
              onPressed: () {},
            ),
            label: '10s',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.skip_next, color: Colors.grey),
              onPressed: () {},
            ),
            label: '1m',
          ),
        ],
      ),
    );
  }
}
