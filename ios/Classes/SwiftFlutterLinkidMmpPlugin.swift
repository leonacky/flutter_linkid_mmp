import Flutter
import UIKit
import linkid_mmp

public class SwiftFlutterLinkidMmpPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_linkid_mmp", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterLinkidMmpPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      if(call.method.elementsEqual("initSDK")) {
          if let args = call.arguments as? Dictionary<String, Any>, let partnerCode = args["partnerCode"] as? String {
              print("initSDK \(partnerCode)")
              LinkIdMMP.intSDK(partnerCode: partnerCode)
              result(true)
          } else {
              result(false)
          }
      } else if(call.method.elementsEqual("event")) {
          if let args = call.arguments as? Dictionary<String, Any>, let event = args["eventName"] as? String {
              print(event)
              if let data = args["data"] as? [String: Any] {
                  LinkIdMMP.logEvent(name: event, data: data)
              } else {
                  LinkIdMMP.logEvent(name: event, data: nil)
              }
              result(true)
          } else {
              result(false)
          }
      } else if(call.method.elementsEqual("setUserInfo")) {
          if let args = call.arguments as? Dictionary<String, Any>, let data = args["data"] as? [String: Any] {
              print(data)
              let userInfo = UserInfo.fromDictionary(data: data)
              LinkIdMMP.setUserInfo(userInfo: userInfo)
              result(true)
          } else {
              result(false)
          }
      } else if(call.method.elementsEqual("setCurrentScreen")) {
          if let args = call.arguments as? Dictionary<String, Any>, let screenName = args["screenName"] as? String {
              print(screenName)
              LinkIdMMP.setCurrentScreen(screenName)
              result(true)
          } else {
              result(false)
          }
      }
    result("iOS " + UIDevice.current.systemVersion)
  }
}
