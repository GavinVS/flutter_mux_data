import Flutter
import UIKit

public class MuxDataPlugin: NSObject, FlutterPlugin {
    private var muxStats: MuxStats?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "plugins.flutter.io/mux_data", binaryMessenger: registrar.messenger())
        let instance = MuxDataPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as! [String: Any]

        if (call.method == "init") {
            guard muxStats == nil else {
                result(FlutterError(code: "", message: "MuxStats handler already initialized.", details: nil))
                return
            }
            muxStats = MuxStats(environmentKey: args["environmentKey"] as! String, viewerId: args["viewerId"] as! String)
            result(nil)
            return
        }

        guard let muxStats = muxStats else {
            result(FlutterError(code: "", message: "Uninitialized MuxStats handler.", details: nil))
            return
        }

        print(call.method)

        switch (call.method) {
        case "playerReady":
            muxStats.playerReady()
            break
        case "viewInit":
            muxStats.viewInit()
            break
        case "videoChange":
            break
        case "play":
            muxStats.play()
            break
        case "playing":
            muxStats.playing()
            break
        case "paused":
            muxStats.pause()
            break
        case "timeUpdate":
            muxStats.timeUpdate(args!["playheadTimeMillis"] as! Int)
            break
        case "seeking":
            muxStats.seeking()
            break
        case "seeked":
            muxStats.seeked()
            break
        case "rebufferStart":
            muxStats.rebufferStart()
            break
        case "rebufferEnd":
            muxStats.rebufferEnd()
            break
        case "error":
            muxStats.error(code: args!["code"] as! Int, message: args!["message"] as! String)
            break
        case "ended":
            muxStats.ended()
            break
        case "renditionChange":
            break
        case "orientationChange":
            break
        case "viewEnd":
            break
        default:
            result(FlutterMethodNotImplemented)
            return
        }

        result(nil)
    }
}
