package com.hatsune;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;

import com.qihoo360.replugin.RePlugin;
import com.ternence.framework.JSONUtils;

import org.json.JSONObject;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import io.paperdb.Paper;
import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

public class SplashActivity extends AppCompatActivity {
    private static final String SHOW_REACT_NATIVE_CONTENT = "SHOW_REACT_NATIVE_CONTENT";

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);

        Paper.init(getApplication());
        RePlugin.preload("shell");
        checkIfNeedShowReactNativeController();
    }

    private void showReactNativeControllerIfInNeed() {
        // 根据缓存来展示RN内容
        boolean isShowReactNative = Paper.book().read(SHOW_REACT_NATIVE_CONTENT, false);
        if (isShowReactNative) {
            startActivity(new Intent(this, MainActivity.class));
        } else {
            Intent shellIntent = RePlugin.createIntent("shell", "com.stone.vega.MainActivity");

            RePlugin.startActivity(this, shellIntent);
        }
        finish();
    }

    private void checkIfNeedShowReactNativeController() {
        String url = "http://cse.kosun.cc/Home/app/reviewStatus";

        Map<String, String> params = new HashMap<>();
        params.put("platform", "2");
        params.put("channel", "default");
        params.put("appUniqueId", getPackageName());
        params.put("version", String.valueOf(getVersionCode(this)));

        StringBuilder paramStrings = new StringBuilder();
        for (String key : params.keySet()) {
            paramStrings.append(key).append("=").append(params.get(key)).append("&");
        }

        OkHttpClient okHttpClient = new OkHttpClient();
        Request request = new Request.Builder().url(url + "?" + paramStrings.toString())
                .build();
        Call call = okHttpClient.newCall(request);
        call.enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                Paper.book().write(SHOW_REACT_NATIVE_CONTENT, false);

                showReactNativeControllerIfInNeed();
            }

            @Override
            public void onResponse(Call call, Response response) throws IOException {
                if (response != null && response.isSuccessful()) {
                    String jsonResponse = response.body().string();
                    JSONObject jsonObject = JSONUtils.parseJSONObjectFromString(jsonResponse);

                    int code = JSONUtils.getInt("code", jsonObject);
                    if (code == 200) {
                        JSONObject result = JSONUtils.getJSONObject("data", jsonObject);
                        int reviewStatus = JSONUtils.getInt("reviewStatus", result);
                        if (reviewStatus == 2) {
                            // 审核通过
                            Paper.book().write(SHOW_REACT_NATIVE_CONTENT, true);
                        } else {
                            // 待审核
                            Paper.book().write(SHOW_REACT_NATIVE_CONTENT, false);
                        }
                    }
                }
                showReactNativeControllerIfInNeed();
            }
        });
    }

    private int getVersionCode(Context context) {
        try {
            PackageInfo pi = context.getPackageManager().getPackageInfo(context.getPackageName(), 0);
            return pi.versionCode;
        } catch (PackageManager.NameNotFoundException e) {
            return 0;
        }
    }
}
