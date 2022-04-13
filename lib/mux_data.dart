import 'package:better_player/better_player.dart';

import 'mux_data_platform_interface.dart';

extension MuxStatsExtension on BetterPlayerController {
  Future<void> addMuxListener({required String environmentKey, required String viewerId}) async {
    final muxHandler = _BetterPlayerMuxHandler();
    await muxHandler.init(environmentKey: environmentKey, viewerId: viewerId);
    addEventsListener(muxHandler.handle);
  }
}

enum _PlayerState {
  init,
  playing,
  paused,
  seeking,
  buffering,
  finished,
}

class _BetterPlayerMuxHandler {
  final MuxDataPlatform _muxHandler;
  var _state = _PlayerState.init;

  _BetterPlayerMuxHandler(): _muxHandler = MuxDataPlatform.instance;

  Future<void> init({required String environmentKey, required String viewerId}) async {
    await _muxHandler.init(environmentKey: environmentKey, viewerId: viewerId);
  }

  void handle(BetterPlayerEvent event) {
    print(event.betterPlayerEventType);
    print(event.parameters);

    switch (event.betterPlayerEventType) {
      case BetterPlayerEventType.play:
        _play();
        break;
      case BetterPlayerEventType.pause:
        _pause();
        break;
      case BetterPlayerEventType.seekTo:
        _seekTo();
        break;
      case BetterPlayerEventType.finished:
        _finished();
        break;
      case BetterPlayerEventType.exception:
        _exception(0, '');
        break;
      case BetterPlayerEventType.progress:
        _progress((event.parameters!['progress'] as Duration).inMilliseconds);
        break;
      default:
        break;
    }
  }

  void _play() {
    switch (_state) {
      case _PlayerState.playing:
        return;
      case _PlayerState.seeking:
        _muxHandler.seekedEvent();
        break;
      case _PlayerState.buffering:
        _muxHandler.bufferingEndEvent();
        break;
      default:
        break;
    }

    _state = _PlayerState.playing;
    _muxHandler.playEvent();
    _muxHandler.playingEvent();
  }

  void _pause() {
    switch (_state) {
      case _PlayerState.paused:
        return;
      case _PlayerState.seeking:
        _muxHandler.seekedEvent();
        break;
      case _PlayerState.buffering:
        _muxHandler.bufferingEndEvent();
        break;
      default:
        break;
    }

    _state = _PlayerState.paused;
    _muxHandler.pauseEvent();
  }

  void _seekTo() {
    switch (_state) {
      case _PlayerState.buffering:
        _muxHandler.bufferingEndEvent();
        break;
      default:
        break;
    }

    _state = _PlayerState.seeking;
    _muxHandler.seekingEvent();
  }

  void _finished() {
    switch (_state) {
      case _PlayerState.seeking:
        _muxHandler.seekedEvent();
        break;
      case _PlayerState.buffering:
        _muxHandler.bufferingEndEvent();
        break;
      default:
        break;
    }

    _state = _PlayerState.finished;
    _muxHandler.endedEvent();
  }

  void _exception(int code, String message) {
    _muxHandler.errorEvent(code, message);
  }

  // TODO: Buffering.

  void _progress(int playheadTimeMillis) {
    // TODO: Must be playing?
    _muxHandler.timeUpdate(playheadTimeMillis);
  }
}
