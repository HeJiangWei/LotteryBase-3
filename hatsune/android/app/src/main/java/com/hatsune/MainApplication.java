package com.hatsune;

import android.content.Context;

import com.RNFetchBlob.RNFetchBlobPackage;
import com.facebook.react.ReactApplication;
import com.facebook.react.ReactNativeHost;
import com.facebook.react.ReactPackage;
import com.facebook.react.shell.MainReactPackage;
import com.facebook.soloader.SoLoader;
import com.jadsonlourenco.RNShakeEvent.RNShakeEventPackage;
import com.learnium.RNDeviceInfo.RNDeviceInfo;
import com.liuchungui.react_native_umeng_push.UmengPushApplication;
import com.liuchungui.react_native_umeng_push.UmengPushPackage;
import com.microsoft.codepush.react.CodePush;
import com.oblador.keychain.KeychainPackage;
import com.qihoo360.replugin.RePlugin;
import com.rnfs.RNFSPackage;
import com.zmxv.RNSound.RNSoundPackage;

import java.util.Arrays;
import java.util.List;

public class MainApplication extends UmengPushApplication implements ReactApplication {

    private final ReactNativeHost mReactNativeHost = new ReactNativeHost(this) {

        @Override
        protected String getJSBundleFile() {
            return CodePush.getJSBundleFile();
        }

        @Override
        protected boolean getUseDeveloperSupport() {
            return BuildConfig.DEBUG;
        }

        @Override
        protected List<ReactPackage> getPackages() {
            return Arrays.<ReactPackage>asList(
                    new MainReactPackage(),
                    new UmengPushPackage(),
                    new RNSoundPackage(),
                    new RNShakeEventPackage(),
                    new KeychainPackage(),
                    new RNFSPackage(),
                    new UmengReactPackage(),
                    new RNFetchBlobPackage(),
                    new RNDeviceInfo(),
                    new CodePush(BuildConfig.CODE_PUSH_KEY, getApplicationContext(), BuildConfig.DEBUG, "http://api.codepush.cc")
            );
        }
    };

    @Override
    public ReactNativeHost getReactNativeHost() {
        return mReactNativeHost;
    }

    @Override
    protected void attachBaseContext(Context base)
    {
        super.attachBaseContext(base);

        RePlugin.App.attachBaseContext(this);
    }

    @Override
    public void onCreate() {
        super.onCreate();

        RePlugin.App.onCreate();
        SoLoader.init(this, /* native exopackage */ false);
        mPushAgent.setResourcePackageName("com.hatsune");
    }
}
