package com.linkid.flutter_linkid_mmp;

import android.content.Context;
import android.content.Intent;
import android.util.Log;

import androidx.annotation.NonNull;

import com.linkid.mmp.AdItem;
import com.linkid.mmp.AdResultListener;
import com.linkid.mmp.Airflex;
import com.linkid.mmp.AirflexAdHelper;
import com.linkid.mmp.AirflexOptions;
import com.linkid.mmp.DeepLink;
import com.linkid.mmp.DeepLinkBuilder;
import com.linkid.mmp.DeepLinkBuilderError;
import com.linkid.mmp.DeepLinkBuilderListener;
import com.linkid.mmp.DeepLinkBuilderResult;
import com.linkid.mmp.DeepLinkHandler;
import com.linkid.mmp.ProductItem;
import com.linkid.mmp.UserInfo;

import java.util.EventListener;
import java.util.HashMap;
import java.util.List;
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

    private boolean showLog = false;

    private DeepLinkHandler deepLinkHandler;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_linkid_mmp");
        channel.setMethodCallHandler(this);
        deepLinkHandler = new DeepLinkHandler() {
            @Override
            public void onReceivedDeeplink(String redirectUrl, String longLink, String error) {
                Log.e(Airflex.TAG, "Flutter Plugin onReceivedDeeplink " + longLink);
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
        } else if (call.method.equals("removeUserToken")) {
            Airflex.removeUserToken();
        } else if (call.method.equals("initSDK")) {
            try {
                if (call.hasArgument("partnerCode")) {
                    String partnerCode = call.argument("partnerCode");
                    String appSecret = call.argument("appSecret");
                    AirflexOptions options = new AirflexOptions();
                    options.showLog = showLog;
                    Airflex.initSDK(context, partnerCode, appSecret, options);
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
                    showLog = devMode;
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
        } else if (call.method.equals("setProductList")) {
            try {
                if (call.hasArgument("listName") && call.hasArgument("products")) {
                    String listName = call.argument("listName");
                    List<Map<String, Object>> data = call.argument("products");
                    if (listName != null && listName != "" && data != null && data.size() > 0) {
                        Airflex.setProductList(listName, ProductItem.fromList(data));
                        result.success(true);
                    } else {
                        result.success(false);
                    }
                } else {
                    result.success(false);
                }
            } catch (Exception e) {
                result.success(false);
                e.printStackTrace();
            }
        } else if (call.method.equals("createLink")) {
            try {
                if (call.hasArgument("params")) {
                    Map<String, Object> params = call.argument("params");
                    DeepLinkBuilder builder = new DeepLinkBuilder();
                    builder.createLink(params, new DeepLinkBuilderListener() {
                        @Override
                        public void onSuccess(DeepLinkBuilderResult _result) {
                            Map<String, Object> data = new HashMap<>();
                            data.put("success", true);
                            data.put("message", "Success");
                            data.put("shortLink", _result.shortLink);
                            data.put("longLink", _result.longLink);
                            data.put("qrLink", _result.qrLink);
                            result.success(data);
                        }

                        @Override
                        public void onError(DeepLinkBuilderError error) {
                            Map<String, Object> data = new HashMap<>();
                            data.put("success", false);
                            data.put("message", error.message);
                            data.put("shortLink", "");
                            data.put("longLink", "");
                            result.success(data);
                        }
                    });
                } else {
                    Map<String, Object> data = new HashMap<>();
                    data.put("success", false);
                    data.put("message", "Cannot create link without params");
                    data.put("shortLink", "");
                    data.put("longLink", "");
                    result.success(data);
                }
            } catch (Exception e) {
                Map<String, Object> data = new HashMap<>();
                data.put("success", false);
                data.put("message", "Cannot create link");
                data.put("shortLink", "");
                data.put("longLink", "");
                result.success(data);
                e.printStackTrace();
            }
        } else if (call.method.equals("getAd")) {
            try {
                if (call.hasArgument("adId") && call.hasArgument("adType")) {
                    String adId = call.argument("adId");
                    String adType = call.argument("adType");
                    AirflexAdHelper.getAd(adId, adType, new AdResultListener() {

                        @Override
                        public void onSuccess(AdItem adItem) {
                            if (adItem != null) {
                                Map<String, Object> data = new HashMap<>();
                                data.put("success", false);
                                data.put("message", "Success");
                                data.put("adItem", adItem.toJsonString());
                                result.success(data);
                            } else {
                                Map<String, Object> data = new HashMap<>();
                                data.put("success", false);
                                data.put("message", "Cannot get ad");
                                data.put("adItem", null);
                                result.success(data);
                            }
                        }

                        @Override
                        public void onFailure(String s, int i) {
                            Map<String, Object> data = new HashMap<>();
                            data.put("success", false);
                            data.put("message", s);
                            data.put("adItem", null);
                            result.success(data);
                        }
                    });
                } else {
                    Map<String, Object> data = new HashMap<>();
                    data.put("success", false);
                    data.put("message", "Cannot get ad without params");
                    data.put("adItem", null);
                    result.success(data);
                }
            } catch (Exception e) {
                Map<String, Object> data = new HashMap<>();
                data.put("success", false);
                data.put("message", "Cannot get ad");
                data.put("adItem", null);
                result.success(data);
                e.printStackTrace();
            }
        } else if (call.method.equals("trackAdImpression")) {
            try {
                if (call.hasArgument("adId")) {
                    String adId = call.argument("adId");
                    String productId = call.argument("productId")+"";
                    AirflexAdHelper.trackImpression(adId, productId);
                    result.success(true);
                } else {
                    result.success(false);
                }
            } catch (Exception e) {
                result.success(false);
                e.printStackTrace();
            }
        } else if (call.method.equals("trackAdClick")) {
            try {
                if (call.hasArgument("adId")) {
                    String adId = call.argument("adId");
                    String productId = call.argument("productId")+"";
                    AirflexAdHelper.trackClick(adId, productId);
                    result.success(true);
                } else {
                    result.success(false);
                }
            } catch (Exception e) {
                result.success(false);
                e.printStackTrace();
            }
        } else if (call.method.equals("createShortLink")) {
            try {
                if (call.hasArgument("longLink")) {
                    String longLink = call.argument("longLink");
                    String name = call.argument("name");
                    String shortLinkId = call.argument("shortLinkId");
                    DeepLinkBuilder builder = new DeepLinkBuilder();
                    builder.createShortLink(longLink, name, shortLinkId, new DeepLinkBuilderListener() {
                        @Override
                        public void onSuccess(DeepLinkBuilderResult _result) {
                            Map<String, Object> data = new HashMap<>();
                            data.put("success", true);
                            data.put("message", "Success");
                            data.put("shortLink", _result.shortLink);
                            data.put("longLink", _result.longLink);
                            data.put("qrLink", _result.qrLink);
                            result.success(data);
                        }

                        @Override
                        public void onError(DeepLinkBuilderError error) {
                            Map<String, Object> data = new HashMap<>();
                            data.put("success", false);
                            data.put("message", error.message);
                            data.put("shortLink", "");
                            data.put("longLink", "");
                            result.success(data);
                        }
                    });
                } else {
                    Map<String, Object> data = new HashMap<>();
                    data.put("success", false);
                    data.put("message", "Cannot create link without params");
                    data.put("shortLink", "");
                    data.put("longLink", "");
                    result.success(data);
                }
            } catch (Exception e) {
                Map<String, Object> data = new HashMap<>();
                data.put("success", false);
                data.put("message", "Cannot create link");
                data.put("shortLink", "");
                data.put("longLink", "");
                result.success(data);
                e.printStackTrace();
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
        // Log.e(Airflex.TAG, "Flutter Plugin onNewIntent " + intent.getData().toString());
        Airflex.handleDeepLink(context, intent, deepLinkHandler);
        return false;
    }
}
