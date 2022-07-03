// ReactNativeStarMicronicsModule.java

package com.rnstarmicro;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;

public class ReactNativeStarMicronicsModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    public ReactNativeStarMicronicsModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "ReactNativeStarMicronicsIO";
    }

    @ReactMethod
    public void stopDiscoverScales(Promise promise) {
        promise.resolve(null);
    }

    @ReactMethod
    public void setupScales(Promise promise) {
        promise.resolve(null);
    }

    @ReactMethod
    public void discoverScales(Promise promise) {
        promise.resolve(null);
    }
}
