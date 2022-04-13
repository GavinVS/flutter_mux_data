import 'package:flutter/material.dart';
import 'package:mux_data_example/player_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _playbackId = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mux example app'),
        ),
        body: Column(
          children: [
            TextField(
              onChanged: (text) => setState(
                () {
                  _playbackId = text;
                },
              ),
            ),
            Builder(
              builder: (context) => Material(
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlayerPage(playbackId: _playbackId)),
                  ),
                  child: const Text('Play'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
