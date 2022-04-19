//
//  MuxStats.swift
//  mux_data
//
//  Created by Gavin Saldanha on 4/13/22.
//

import Foundation
import MuxCore
import AVKit

class MuxStats {
    private var width = 0
    private var height = 0
    private var isFullscreen = false
    private var isPaused = false
    private var playheadTime = 0

    init(environmentKey: String, viewerId: String) {
        let envData = MUXSDKEnvironmentData()
        envData.muxViewerId = UIDevice.current.identifierForVendor?.uuidString

        let customerPlayerData = MUXSDKCustomerPlayerData()
        customerPlayerData.environmentKey = environmentKey
        customerPlayerData.viewerUserId = viewerId

        let viewerData = MUXSDKViewerData()
        viewerData.viewerApplicationName = Bundle.main.bundleIdentifier

        let shortVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String

        if let shortVersion = shortVersion, let version = version {
            viewerData.viewerApplicationVersion = "\(shortVersion)+\(version)"
        } else {
            viewerData.viewerApplicationVersion = version
        }

        switch (UIDevice.current.userInterfaceIdiom) {
        case .phone:
            viewerData.viewerDeviceCategory = "phone"
            viewerData.muxViewerDeviceCategory = "phone"
            break
        case .pad:
            viewerData.viewerDeviceCategory = "tablet"
            viewerData.muxViewerDeviceCategory = "tablet"
            break
        default:
            break
        }

        viewerData.viewerDeviceManufacturer = "Apple"
        viewerData.viewerOsFamily = UIDevice.current.systemName
        viewerData.viewerOsVersion = UIDevice.current.systemVersion
        viewerData.viewerDeviceModel = UIDevice.current.model

        viewerData.muxViewerDeviceManufacturer = "Apple"
        viewerData.muxViewerOsFamily = UIDevice.current.systemName
        viewerData.muxViewerOsVersion = UIDevice.current.systemVersion
        viewerData.muxViewerDeviceModel = UIDevice.current.model

        let dataEvent = MUXSDKDataEvent()
        dataEvent.environmentData = envData
        dataEvent.viewerData = viewerData
        dataEvent.customerPlayerData = customerPlayerData

        MUXSDKCore.dispatchGlobalDataEvent(dataEvent)
        MUXSDKCore.dispatchEvent(dataEvent, forPlayer: "")

        // To stay consistent with Android, need to call playerReady() and viewInit() here.
        viewInit()
        playerReady()
    }

    func playerReady() {
        let event = MUXSDKPlayerReadyEvent()
        event.playerData = playerData
        dispatch(event)
    }

    func viewInit() {
        let event = MUXSDKViewInitEvent()
        event.playerData = playerData
        dispatch(event)
    }

    // Unused
    func videoChange() {}

    func play() {
        isPaused = false
        let event = MUXSDKPlayEvent()
        event.playerData = playerData
        dispatch(event)
    }

    func playing() {
        let event = MUXSDKPlayingEvent()
        event.playerData = playerData
        dispatch(event)
    }

    func pause() {
        isPaused = true
        let event = MUXSDKPauseEvent()
        event.playerData = playerData
        dispatch(event)
    }

    func timeUpdate(_ playheadTimeMillis: Int) {
        playheadTime = playheadTimeMillis
        let event  = MUXSDKTimeUpdateEvent()
        event.playerData = playerData
        dispatch(event)
    }

    func seeking() {
        let event = MUXSDKInternalSeekingEvent()
        event.playerData = playerData
        dispatch(event)
    }

    func seeked() {
        let event = MUXSDKSeekedEvent()
        event.playerData = playerData
        dispatch(event)
    }

    func rebufferStart() {
        // TODO.
    }

    func rebufferEnd() {
        // TODO.
    }

    func error(code: Int, message: String) {
        let event = MUXSDKErrorEvent()
        event.playerData = playerData
        event.playerData?.playerErrorCode = String(code)
        event.playerData?.playerErrorMessage = message
        dispatch(event)
    }

    func ended() {
        let event = MUXSDKEndedEvent()
        event.playerData = playerData
        dispatch(event)
    }

    // Unused.
    func renditionChange(sourceWidth: Int, sourceHeight: Int, bitrate: Int, framerate: Float) {
        let event = MUXSDKRenditionChangeEvent()
        width = sourceWidth
        height = sourceHeight
        event.playerData = playerData
        dispatch(event)
    }

    // Unused.
    func orientationChange() {
        let event = MUXSDKOrientationChangeEvent()
        event.playerData = playerData
        dispatch(event)
    }

    // Unused.
    func viewEnd() {
        let event = MUXSDKViewEndEvent()
        event.playerData = playerData
        dispatch(event)
    }

    private var playerData: MUXSDKPlayerData {
        let playerData = MUXSDKPlayerData()
        playerData.playerMuxPluginName = "apple-mux"
        playerData.playerMuxPluginVersion = ""
        playerData.playerSoftwareName = ""
        playerData.playerLanguageCode = Locale.preferredLanguages.first
        playerData.playerWidth = NSNumber(value: width)
        playerData.playerHeight = NSNumber(value: height)
        playerData.playerIsFullscreen = String(isFullscreen)
        playerData.playerIsPaused = NSNumber(value: isPaused)
        playerData.playerPlayheadTime = NSNumber(value: playheadTime)
        return playerData
    }

    private func dispatch(_ event: MUXSDKEventTyping) {
        MUXSDKCore.dispatchEvent(event, forPlayer: "")
    }
}
