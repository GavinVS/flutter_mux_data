package com.example.mux_data;

import android.content.Context;
import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** MuxDataPlugin */
public class MuxDataPlugin implements FlutterPlugin, MethodCallHandler {
    private MethodChannel channel;
    private Context context;
    private PlayerListener listener;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "plugins.flutter.io/mux_data");
        channel.setMethodCallHandler(this);
        context = flutterPluginBinding.getApplicationContext();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        listener = null;
        channel = null;
        context = null;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("init")) {
            listener = new PlayerListener(context, call.argument("environmentKey"), call.argument("viewerId"));
            result.success(null);
            return;
        }
        if (listener == null) {
            result.error("", "Uninitialized MuxStats handler.", null);
            return;
        }

        switch (call.method) {
            case "play":
                listener.play();
                break;
            case "playing":
                listener.playing();
                break;
            case "pause":
                listener.pause();
                break;
            case "timeUpdate":
                listener.timeUpdate(call.argument("playheadTimeMillis"));
                break;
            case "seeking":
                listener.seeking();
                break;
            case "seeked":
                listener.seeked();
                break;
            case "rebufferStart":
                listener.rebufferStart();
                break;
            case "rebufferEnd":
                listener.rebufferEnd();
                break;
            case "error":
                listener.error(call.argument("code"), call.argument("message"));
                break;
            case "ended":
                listener.ended();
                break;
            default:
                result.notImplemented();
                return;
        }

        result.success(null);
    }
}
