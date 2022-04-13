import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_mux_data.dart';

abstract class MuxDataPlatform extends PlatformInterface {
  static final _token = Object();

  static MuxDataPlatform _instance = MethodChannelMuxData();

  static MuxDataPlatform get instance => _instance;

  static set instance(MuxDataPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  MuxDataPlatform() : super(token: _token);

  Future<void> init({required String environmentKey, required String viewerId}) {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future<void> timeUpdate(int playheadTimeMillis) {
    throw UnimplementedError('timeUpdate() has not been implemented.');
  }

  Future<void> playEvent() {
    throw UnimplementedError('playEvent() has not been implemented.');
  }

  Future<void> playingEvent() {
    throw UnimplementedError('playingEvent() has not been implemented.');
  }

  Future<void> pauseEvent() {
    throw UnimplementedError('pauseEvent() has not been implemented.');
  }

  Future<void> seekingEvent() {
    throw UnimplementedError('seekingEvent() has not been implemented.');
  }

  Future<void> seekedEvent() {
    throw UnimplementedError('seekedEvent() has not been implemented.');
  }

  Future<void> bufferingStartEvent() {
    throw UnimplementedError('bufferingStartEvent() has not been implemented.');
  }

  Future<void> bufferingEndEvent() {
    throw UnimplementedError('bufferingEndEvent() has not been implemented.');
  }

  Future<void> errorEvent(int code, String message) {
    throw UnimplementedError('errorEvent() has not been implemented.');
  }

  Future<void> endedEvent() {
    throw UnimplementedError('endedEvent() has not been implemented.');
  }
}
