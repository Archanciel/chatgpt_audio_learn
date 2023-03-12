import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/extract_audio_view_model_bad.dart';

class ExtractAudioScreen extends StatefulWidget {
  static const routeName = '/extract-audio';

  const ExtractAudioScreen({Key? key}) : super(key: key);

  @override
  _ExtractAudioScreenState createState() => _ExtractAudioScreenState();
}

class _ExtractAudioScreenState extends State<ExtractAudioScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final viewModel = Provider.of<ExtractAudioViewModel>(context, listen: false);
    viewModel.extractAudioFromUrl(_urlController.text.trim()).then((success) {
      if (success) {
        Navigator.of(context).pushReplacementNamed('/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred while extracting the audio.'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Extract Audio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter the URL of the video to extract the audio from:',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 16.0),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _urlController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  hintText: 'https://www.youtube.com/watch?v=VIDEO_ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a URL';
                  }
                  if (!Uri.parse(value).isAbsolute) {
                    return 'Please enter a valid URL';
                  }
                  if (!value.contains('youtube.com/watch?v=')) {
                    return 'Please enter a valid YouTube video URL';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _submitForm(context),
              child: Text('Extract Audio'),
            ),
          ],
        ),
      ),
    );
  }
}
