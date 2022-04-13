package com.example.mux_data;

interface MuxEventHandler {
    void videoChange();

    void play();

    void playing();

    void pause();

    void timeUpdate(int playheadTimeMillis);

    void seeking();

    void seeked();

    void rebufferStart();

    void rebufferEnd();

    void error(int code, String message);

    void ended();

    void renditionChange(Integer sourceWidth, Integer sourceHeight, Integer bitrate, Float framerate);

    enum Orientation {
        UNKNOWN,
        PORTRAIT,
        LANDSCAPE,
    }

    void orientationChange(Orientation orientation);
}
