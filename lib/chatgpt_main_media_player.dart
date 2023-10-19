import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: MediaPlayerView(),
    );
  }
}

class MediaPlayerView extends StatefulWidget {
  @override
  State<MediaPlayerView> createState() => _MediaPlayerViewState();
}

class _MediaPlayerViewState extends State<MediaPlayerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Opus'),
        actions: [
          IconButton(
            icon: Icon(Icons.bluetooth_audio),
            onPressed: () {},
          ),
          SizedBox(width: 20),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Various',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Center(
              child: IconButton(
                icon: Icon(Icons.play_arrow, size: 70),
                onPressed: () {},
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('0:43'),
                Expanded(
                  child: Slider(
                    value: 0.43,
                    onChanged: (value) {},
                    min: 0,
                    max: 2.55,
                  ),
                ),
                Text('2:55:12'),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous, size: 40),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.replay_10, size: 40),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.pause, size: 60),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.forward_10, size: 40),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.skip_next, size: 40),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 40),
            Text(
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
              icon: Icon(Icons.shuffle, color: Colors.grey),
              onPressed: () {},
            ),
            label: '1m',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.replay_10, color: Colors.grey),
              onPressed: () {},
            ),
            label: '10s',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.play_arrow, color: Colors.white),
              onPressed: () {},
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.forward_10, color: Colors.grey),
              onPressed: () {},
            ),
            label: '10s',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.skip_next, color: Colors.grey),
              onPressed: () {},
            ),
            label: '1m',
          ),
        ],
      ),
    );
  }
}
