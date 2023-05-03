import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter YouTube Video Launcher',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter YouTube Video Launcher'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Audio> _audioList = [
    Audio(title: 'Audio 1', videoUrl: 'https://youtu.be/jBV1xEfyONU'),
    Audio(title: 'Audio 2', videoUrl: 'https://youtu.be/ItgGzlE9aik'),
    // Add more audio instances here
  ];

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        enableJavaScript: true,
        universalLinksOnly: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _audioList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_audioList[index].title),
            onTap: () => _launchURL(_audioList[index].videoUrl),
          );
        },
      ),
    );
  }
}

class Audio {
  final String title;
  final String videoUrl;

  Audio({required this.title, required this.videoUrl});
}
