package com.example.mux_data;

import android.content.Context;

import com.mux.stats.sdk.core.MuxSDKViewOrientation;
import com.mux.stats.sdk.core.events.EventBus;
import com.mux.stats.sdk.core.events.playback.EndedEvent;
import com.mux.stats.sdk.core.events.playback.PauseEvent;
import com.mux.stats.sdk.core.events.playback.PlayEvent;
import com.mux.stats.sdk.core.events.playback.PlayingEvent;
import com.mux.stats.sdk.core.events.playback.RebufferEndEvent;
import com.mux.stats.sdk.core.events.playback.RebufferStartEvent;
import com.mux.stats.sdk.core.events.playback.RenditionChangeEvent;
import com.mux.stats.sdk.core.events.playback.SeekedEvent;
import com.mux.stats.sdk.core.events.playback.SeekingEvent;
import com.mux.stats.sdk.core.events.playback.TimeUpdateEvent;
import com.mux.stats.sdk.core.events.playback.VideoChangeEvent;
import com.mux.stats.sdk.core.model.CustomerData;
import com.mux.stats.sdk.core.model.CustomerPlayerData;
import com.mux.stats.sdk.core.model.CustomerVideoData;
import com.mux.stats.sdk.core.model.CustomerViewData;
import com.mux.stats.sdk.muxstats.IPlayerListener;
import com.mux.stats.sdk.muxstats.MuxErrorException;
import com.mux.stats.sdk.muxstats.MuxStats;

import java.util.UUID;

class PlayerListener extends EventBus implements IPlayerListener, MuxEventHandler {
    private final MuxStats muxStats;

    private boolean isPaused = true;
    private boolean isBuffering = false;
    private Integer sourceWidth;
    private Integer sourceHeight;
    private Integer bitrate;
    private Float framerate;
    private int playheadTimeMillis;

    PlayerListener(Context context, String environmentKey, String viewerId) {
        super();

        var playerData = new CustomerPlayerData();
        playerData.setEnvironmentKey(environmentKey);
        playerData.setViewerUserId(viewerId);
        var videoData = new CustomerVideoData();
        var viewData = new CustomerViewData();
        viewData.setViewSessionId(UUID.randomUUID().toString());

        MuxStats.setHostDevice(new MuxDevice(context));
        MuxStats.setHostNetworkApi(new MuxNetworkRequest());
        muxStats = new MuxStats(this, "android-player", new CustomerData(playerData, videoData, viewData));
        addListener(muxStats);
    }

    @Override
    public long getCurrentPosition() {
        return playheadTimeMillis;
    }

    @Override
    public String getMimeType() {
        return null;
    }

    @Override
    public Integer getSourceWidth() {
        return sourceWidth;
    }

    @Override
    public Integer getSourceHeight() {
        return sourceHeight;
    }

    @Override
    public Integer getSourceAdvertisedBitrate() {
        return bitrate;
    }

    @Override
    public Float getSourceAdvertisedFramerate() {
        return framerate;
    }

    @Override
    public Long getSourceDuration() {
        return null;
    }

    @Override
    public boolean isPaused() {
        return isPaused;
    }

    @Override
    public boolean isBuffering() {
        return isBuffering;
    }

    @Override
    public int getPlayerViewWidth() {
        return 0;
    }

    @Override
    public int getPlayerViewHeight() {
        return 0;
    }

    @Override
    public Long getPlayerProgramTime() {
        return null;
    }

    @Override
    public Long getPlayerManifestNewestTime() {
        return null;
    }

    @Override
    public Long getVideoHoldback() {
        return null;
    }

    @Override
    public Long getVideoPartHoldback() {
        return null;
    }

    @Override
    public Long getVideoPartTargetDuration() {
        return null;
    }

    @Override
    public Long getVideoTargetDuration() {
        return null;
    }

    // Unused.
    @Override
    public void videoChange() {
        dispatch(new VideoChangeEvent(null));
    }

    @Override
    public void play() {
        isPaused = false;
        dispatch(new PlayEvent(null));
    }

    @Override
    public void playing() {
        dispatch(new PlayingEvent(null));
    }

    @Override
    public void pause() {
        isPaused = true;
        dispatch(new PauseEvent(null));
    }

    @Override
    public void timeUpdate(int playheadTimeMillis) {
        this.playheadTimeMillis = playheadTimeMillis;
        dispatch(new TimeUpdateEvent(null));
    }

    @Override
    public void seeking() {
        dispatch(new SeekingEvent(null));
    }

    @Override
    public void seeked() {
        dispatch(new SeekedEvent(null));
    }

    @Override
    public void rebufferStart() {
        isBuffering = true;
        dispatch(new RebufferStartEvent(null));
    }

    @Override
    public void rebufferEnd() {
        isBuffering = false;
        dispatch(new RebufferEndEvent(null));
    }

    @Override
    public void error(int code, String message) {
        muxStats.error(new MuxErrorException(code, message));
    }

    @Override
    public void ended() {
        dispatch(new EndedEvent(null));
    }

    // Unused.
    @Override
    public void renditionChange(Integer sourceWidth, Integer sourceHeight, Integer bitrate, Float framerate) {
        this.sourceWidth = sourceWidth;
        this.sourceHeight = sourceHeight;
        this.bitrate = bitrate;
        this.framerate = framerate;
        dispatch(new RenditionChangeEvent(null));
    }

    // Unused.
    @Override
    public void orientationChange(Orientation orientation) {
        switch (orientation) {
            case UNKNOWN:
                muxStats.orientationChange(MuxSDKViewOrientation.UNKNOWN);
                break;
            case PORTRAIT:
                muxStats.orientationChange(MuxSDKViewOrientation.PORTRAIT);
                break;
            case LANDSCAPE:
                muxStats.orientationChange(MuxSDKViewOrientation.LANDSCAPE);
                break;
        }
    }
}
