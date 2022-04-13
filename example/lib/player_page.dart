import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:mux_data/mux_data.dart';

class PlayerPage extends StatefulWidget {
  final String playbackId;

  const PlayerPage({Key? key, required this.playbackId}) : super(key: key);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late final BetterPlayerController _controller;

  @override
  void initState() {
    super.initState();

    final source = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      'https://stream.mux.com/${widget.playbackId}.m3u8',
      liveStream: true,
    );

    _controller = BetterPlayerController(
      const BetterPlayerConfiguration(autoDispose: false, autoPlay: true),
      betterPlayerDataSource: source,
    );

    _controller.addMuxListener(environmentKey: 'mux-env-key', viewerId: 'viewer-id');
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: BetterPlayer(
        controller: _controller,
      ),
    );
  }
}
