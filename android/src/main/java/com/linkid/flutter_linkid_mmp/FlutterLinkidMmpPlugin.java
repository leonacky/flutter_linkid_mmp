package com.linkid.flutter_linkid_mmp;

import android.content.Context;

import androidx.annotation.NonNull;

import com.linkid.mmp.LinkMMP;
import com.linkid.mmp.UserInfo;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** FlutterLinkidMmpPlugin */
public class FlutterLinkidMmpPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_linkid_mmp");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("initSDK")) {
      try {
        if(call.hasArgument("partnerCode")) {
          String partnerCode = call.argument("partnerCode");
          LinkIdMMP.initSDK(context, partnerCode);
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
        if(call.hasArgument("eventName")) {
          String eventName = call.argument("eventName");
          LinkIdMMP.logEvent(eventName, null);
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
        if(call.hasArgument("screenName")) {
          String screenName = call.argument("screenName");
          LinkIdMMP.setCurrentScreen(screenName);
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
        if(call.hasArgument("data")) {
          Map<String, Object> data = call.argument("data");
          LinkIdMMP.setUserInfo(UserInfo.fromMap(data));
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
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    context = binding.getActivity().getApplicationContext();
  }

  @Override
  public void onDetachedFromActivity() {

  }
}
