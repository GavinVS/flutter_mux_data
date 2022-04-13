import 'package:flutter/services.dart';
import 'package:mux_data/mux_data_platform_interface.dart';

class MethodChannelMuxData extends MuxDataPlatform {
  static const _channel = MethodChannel('plugins.flutter.io/mux_data');

  @override
  Future<void> init({required String environmentKey, required String viewerId}) {
    return _channel.invokeMethod('init', {'environmentKey': environmentKey, 'viewerId': viewerId});
  }

  @override
  Future<void> timeUpdate(int playheadTimeMillis) {
    return _channel.invokeMethod('timeUpdate', {'playheadTimeMillis': playheadTimeMillis});
  }

  @override
  Future<void> playEvent() {
    return _channel.invokeMethod('play');
  }

  @override
  Future<void> playingEvent() {
    return _channel.invokeMethod('playing');
  }

  @override
  Future<void> pauseEvent() {
    return _channel.invokeMethod('playing');
  }

  @override
  Future<void> seekingEvent() {
    return _channel.invokeMethod('seeking');
  }

  @override
  Future<void> seekedEvent() {
    return _channel.invokeMethod('seeked');
  }

  @override
  Future<void> bufferingStartEvent() {
    return _channel.invokeMethod('rebufferStart');
  }

  @override
  Future<void> bufferingEndEvent() {
    return _channel.invokeMethod('rebufferEnd');
  }

  @override
  Future<void> errorEvent(int code, String message) {
    return _channel.invokeMethod('error', {'code': code, 'message': message});
  }

  @override
  Future<void> endedEvent() {
    return _channel.invokeMethod('ended');
  }
}
