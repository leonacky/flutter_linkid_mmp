package com.linkid.flutter_linkid_mmp;

import android.content.Context;
import android.content.Intent;
import android.util.Log;

import androidx.annotation.NonNull;

import com.linkid.mmp.Airflex;
import com.linkid.mmp.DeepLink;
import com.linkid.mmp.DeepLinkHandler;
import com.linkid.mmp.UserInfo;

import java.util.EventListener;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

/**
 * FlutterLinkidMmpPlugin
 */
public class FlutterLinkidMmpPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.NewIntentListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context context;

    private DeepLinkHandler deepLinkHandler;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_linkid_mmp");
        channel.setMethodCallHandler(this);
        deepLinkHandler = new DeepLinkHandler() {
            @Override
            public void onReceivedDeeplink(String s) {
                Log.e(Airflex.TAG, "Flutter Plugin onReceivedDeeplink " + s);
                checkDeepLink();
            }
        };
    }

    void checkDeepLink() {
        if (DeepLink.getCurrentDeepLink() != null && !DeepLink.getCurrentDeepLink().isEmpty()) {
            channel.invokeMethod("onDeepLink", DeepLink.getCurrentDeepLink());
        }
    }
    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("getDeepLink")) {
            checkDeepLink();
        } else if (call.method.equals("initSDK")) {
            try {
                if (call.hasArgument("partnerCode")) {
                    String partnerCode = call.argument("partnerCode");
                    String appSecret = call.argument("appSecret");
                    Airflex.initSDK(context, partnerCode, appSecret);
                    result.success(true);
                } else {
                    result.success(false);
                }
            } catch (Exception e) {
                e.printStackTrace();
                result.success(false);
            }
        } else if (call.method.equals("recordError")) {
            try {
                if (call.hasArgument("name")) {
                    String name = call.argument("name");
                    String stackTrace = call.argument("stackTrace");
                    Airflex.recordError(context, name, stackTrace);
                    result.success(true);
                } else {
                    result.success(false);
                }
            } catch (Exception e) {
                e.printStackTrace();
                result.success(false);
            }
        } else if (call.method.equals("setDevMode")) {
            try {
                if (call.hasArgument("devMode")) {
                    boolean devMode = Boolean.TRUE.equals(call.argument("devMode"));
                    Airflex.setDevMode(devMode);
                    result.success(true);
                } else {
                    result.success(false);
                }
            } catch (Exception e) {
                e.printStackTrace();
                result.success(false);
            }
        } else if (call.method.equals("event")) {
            try {
                if (call.hasArgument("eventName")) {
                    Map<String, Object> data = null;
                    if (call.hasArgument("data")) {
                        data = call.argument("data");
                    }
                    String eventName = call.argument("eventName");
                    Airflex.logEvent(eventName, data);
                    result.success(true);
                } else {
                    result.success(false);
                }
            } catch (Exception e) {
                e.printStackTrace();
                result.success(false);
            }
        } else if (call.method.equals("setCurrentScreen")) {
            try {
                if (call.hasArgument("screenName")) {
                    String screenName = call.argument("screenName");
                    Airflex.setCurrentScreen(screenName);
                    result.success(true);
                } else {
                    result.success(false);
                }
            } catch (Exception e) {
                e.printStackTrace();
                result.success(false);
            }
        } else if (call.method.equals("setUserInfo")) {
            try {
                if (call.hasArgument("data")) {
                    Map<String, Object> data = call.argument("data");
                    Airflex.setUserInfo(UserInfo.fromMap(data));
                    result.success(true);
                } else {
                    result.success(false);
                }
            } catch (Exception e) {
                e.printStackTrace();
                result.success(false);
            }
        } else if (call.method.equals("setRevenue")) {
            try {
                if (call.hasArgument("orderId") && call.hasArgument("amount") && call.hasArgument("currency")) {
                    String orderId = call.argument("orderId");
                    double amount = call.argument("amount");
                    String currency = call.argument("currency");
                    Map<String, Object> data = null;
                    try {
                        data = call.argument("data");
                    } catch (Exception e) {
                    }
                    Airflex.setRevenue(orderId, amount, currency, data);
                    result.success(true);
                } else {
                    result.success(false);
                }
            } catch (Exception e) {
                e.printStackTrace();
                result.success(false);
            }
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        context = binding.getActivity().getApplicationContext();
        Airflex.handleDeepLink(context, binding.getActivity().getIntent(), deepLinkHandler);
        binding.addOnNewIntentListener(this);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        context = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        context = binding.getActivity().getApplicationContext();
        binding.addOnNewIntentListener(this);
    }

    @Override
    public void onDetachedFromActivity() {
        context = null;
    }

    @Override
    public boolean onNewIntent(@NonNull Intent intent) {
        Airflex.handleDeepLink(context, intent, deepLinkHandler);
        return false;
    }
}
