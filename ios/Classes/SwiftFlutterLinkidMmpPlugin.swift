import Flutter
import UIKit
import linkid_mmp

public class SwiftFlutterLinkidMmpPlugin: NSObject, FlutterPlugin {
    var deeplink = ""
    var referalLink = ""
    var channel: FlutterMethodChannel?
    
    static let sharedInstance = SwiftFlutterLinkidMmpPlugin()

    private override init() {
        super.init()
    }
        
    
    public static func register(with registrar: FlutterPluginRegistrar) {

        let instance = SwiftFlutterLinkidMmpPlugin.sharedInstance

        instance.channel = FlutterMethodChannel(name: "flutter_linkid_mmp", binaryMessenger: registrar.messenger())
//        let instance = SwiftFlutterLinkidMmpPlugin()
        registrar.addMethodCallDelegate(instance, channel: instance.channel!)
        registrar.addApplicationDelegate(instance)

    }
    
    func checkDeepLink() {
        if(deeplink != "") {
            channel?.invokeMethod("onDeepLink", arguments: deeplink)
            DeepLinkHandler.setDeepLink(url: deeplink)
        }
    }
    
    func checkDeferredDeepLink() {
        if(referalLink != "") {
            channel?.invokeMethod("onDeferredDeepLink", arguments: referalLink)
            DeepLinkHandler.setDeferredDeepLink(url: referalLink)
        }
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      if(call.method.elementsEqual("initSDK")) {
          if let args = call.arguments as? Dictionary<String, Any>, let partnerCode = args["partnerCode"] as? String, let appSecret = args["appSecret"] as? String {
              print("initSDK \(partnerCode)")
//              let baseUrl = Common.decrypt(encrypted: appSecret, key: partnerCode)
//              LinkIdMMP.intSDKWithBaseUrl(partnerCode: partnerCode, appSecret: appSecret, baseUrl: baseUrl)
              LinkIdMMP.intSDK(partnerCode: partnerCode, appSecret: appSecret)
              result(true)
          } else {
              result(false)
          }
      } else if(call.method.elementsEqual("getDeepLink")) {
          checkDeepLink()
          checkDeferredDeepLink()
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
    
    private func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let url = launchOptions?[UIApplication.LaunchOptionsKey.url] as? URL {
            deeplink = url.absoluteString
            print("deeplink 1 \(deeplink)")
            checkDeepLink()
        }
        return true
    }

    public func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        deeplink = url.absoluteString
        print("deeplink 2 \(deeplink)")
        checkDeepLink()
        return true
    }

    private func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
//            latestLink = userActivity.webpageURL?.absoluteString ?? ""
//            initialLink = latestLink
//            print("deeplink 3 \(latestLink)")
//            return true
//        }
//        return false
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL, let deepLinkString = url.absoluteString.removingPercentEncoding {
                // Navigate to the appropriate content within your app based on the deep link
                referalLink = deepLinkString
                print("referalLink \(referalLink)")
                checkDeferredDeepLink()
                return true
            }
        }
        return false
    }

}
