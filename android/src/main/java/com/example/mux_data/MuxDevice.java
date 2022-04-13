package com.example.mux_data;

import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.SystemClock;

import com.mux.stats.sdk.muxstats.IDevice;
import com.mux.stats.sdk.muxstats.LogPriority;

import java.util.UUID;

class MuxDevice implements IDevice {
    private static final String MUX_DEVICE_ID = "MUX_DEVICE_ID";

    private final String deviceId;
    private final String appName;
    private final String appVersion;

    MuxDevice(Context context) {
        var sharedPreferences = context.getSharedPreferences(MUX_DEVICE_ID, Context.MODE_PRIVATE);
        var deviceId = sharedPreferences.getString(MUX_DEVICE_ID, null);

        if (deviceId == null) {
            deviceId = UUID.randomUUID().toString();
            sharedPreferences.edit().putString(MUX_DEVICE_ID, deviceId).apply();
        }

        this.deviceId = deviceId;
        appName = context.getPackageName();
        String appVersion;

        try {
            appVersion = context.getPackageManager().getPackageInfo(appName, 0).versionName;
        } catch (PackageManager.NameNotFoundException e) {
            appVersion = "unknown";
        }

        this.appVersion = appVersion;
    }

    @Override
    public String getHardwareArchitecture() {
        return Build.HARDWARE;
    }

    @Override
    public String getOSFamily() {
        return "Android";
    }

    @Override
    public String getOSVersion() {
        return String.format("%s (%s)", Build.VERSION.RELEASE, Build.VERSION.SDK_INT);
    }

    @Override
    public String getManufacturer() {
        return Build.MANUFACTURER;
    }

    @Override
    public String getModelName() {
        return Build.MODEL;
    }

    @Override
    public String getPlayerVersion() {
        // TODO.
        return null;
    }

    @Override
    public String getDeviceId() {
        return deviceId;
    }

    @Override
    public String getAppName() {
        return appName;
    }

    @Override
    public String getAppVersion() {
        return appVersion;
    }

    @Override
    public String getPluginName() {
        return BuildConfig.LIBRARY_PACKAGE_NAME;
    }

    @Override
    public String getPluginVersion() {
        return BuildConfig.MUX_PLUGIN_VERSION;
    }

    @Override
    public String getPlayerSoftware() {
        return "ExoPlayer";
    }

    @Override
    public String getNetworkConnectionType() {
        // TODO.
        return null;
    }

    @Override
    public long getElapsedRealtime() {
        return SystemClock.elapsedRealtime();
    }

    @Override
    public void outputLog(LogPriority logPriority, String tag, String msg) {
        // TODO.
    }

    @Override
    public void outputLog(String tag, String msg) {
        outputLog(LogPriority.INFO, tag, msg);
    }
}
