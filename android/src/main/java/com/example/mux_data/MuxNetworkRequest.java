package com.example.mux_data;

import android.util.Log;

import androidx.annotation.NonNull;

import com.mux.stats.sdk.muxstats.INetworkRequest;

import org.json.JSONObject;

import java.io.IOException;
import java.net.URL;
import java.util.Hashtable;
import java.util.Map;
import java.util.regex.Pattern;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.Headers;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

class MuxNetworkRequest implements INetworkRequest {
    private final OkHttpClient client = new OkHttpClient();

    @Override
    public void get(URL url) {
        Log.i("GAVIN HTTP", "making get request");
        var request = new Request.Builder().url(url).build();

        client.newCall(request).enqueue(new NoOpCallback());
    }

    @Override
    public void post(URL url, JSONObject jsonObject, Hashtable<String, String> headers) {
        Log.i("GAVIN HTTP", "making post request");
        var request = new Request.Builder()
            .url(url)
            .post(RequestBody.create(jsonObject.toString(), MediaType.parse("application/json")))
            .headers(Headers.of(headers))
            .build();

        client.newCall(request).enqueue(new NoOpCallback());
    }

    @Override
    public void postWithCompletion(String domain, String propertyKey, String body,
           Hashtable<String, String> headers, IMuxNetworkRequestsCompletion callback) {
        Log.i("GAVIN HTTP", "making post2 request");
        Log.i("POST2", String.format("%s, %s, %s", domain, propertyKey, body));

        try {
            var request = new Request.Builder()
                    .url(String.format("https://%s/android", authority(propertyKey, domain)))
                    .post(RequestBody.create(body, MediaType.parse("application/json")))
                    .headers(Headers.of(headers == null ? Map.of() : headers))
                    .build();

            client.newCall(request).enqueue(new Callback() {
                @Override
                public void onFailure(@NonNull Call call, @NonNull IOException e) {
                    Log.e("POST2 ERROR", e.getMessage());
                    callback.onComplete(false);
                }

                @Override
                public void onResponse(@NonNull Call call, @NonNull Response response) throws IOException {
                    Log.i("POST@ SUCCESS", response.body().string());
                    callback.onComplete(true);
                }
            });
        } catch (Exception e) {
            Log.i("YOOOOOOOOO WTF", e.getMessage());
        }
    }

    private static String authority(String propertykey, String domain) {
        if (Pattern.matches("^[a-z0-9]+$", propertykey)) {
            return propertykey + domain;
        }
        return "img" + domain;
    }

    private static class NoOpCallback implements Callback {
        @Override
        public void onFailure(@NonNull Call call, @NonNull IOException e) {
            Log.e("GAVIN HTTP Error", e.getMessage());
        }

        @Override
        public void onResponse(@NonNull Call call, @NonNull Response response) throws IOException {
            Log.i("GAVIN HTTP", response.body().string());
        }
    }
}
