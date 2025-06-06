import Flutter
import UIKit
import linkid_mmp

public class LinkidMmpPlugin: NSObject, FlutterPlugin {
    
    var deeplink = ""
    var channel: FlutterMethodChannel?
    var showLog: Bool = false
    
    public static let sharedInstance = LinkidMmpPlugin()

    private override init() {
        super.init()
    }
        
    
    public static func register(with registrar: FlutterPluginRegistrar) {

        let instance = LinkidMmpPlugin.sharedInstance
        instance.channel = FlutterMethodChannel(name: "flutter_linkid_mmp", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: instance.channel!)
        registrar.addApplicationDelegate(instance)
    }
    
    func checkDeepLink() {
        if(deeplink != "") {
            channel?.invokeMethod("onDeepLink", arguments: deeplink)
            DeepLinkHandler.setDeepLink(url: deeplink)
        }
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method.elementsEqual("initSDK")) {
            if let args = call.arguments as? Dictionary<String, Any>, let partnerCode = args["partnerCode"] as? String, let appSecret = args["appSecret"] as? String {
                print("initSDK \(partnerCode)")
                let airflexOptions = AirflexOptions()
                airflexOptions.showLog = showLog
                Airflex.initSDK(partnerCode: partnerCode, appSecret: appSecret, options: airflexOptions)
                Airflex.handleDeeplink { url in
                    LinkidMmpPlugin.sharedInstance.handleDeeplink(url: url)
                }
                result(true)
            } else {
                result(false)
            }
        } else if(call.method.elementsEqual("removeUserToken")) {
            Airflex.removeUserToken()
            result(true)
        } else if(call.method.elementsEqual("recordError")) {
            if let args = call.arguments as? Dictionary<String, Any>, let name = args["name"] as? String, let stackTrace = args["stackTrace"] as? String {
                Airflex.recordError(name: name, stackTrace: stackTrace)
                result(true)
            } else {
                result(false)
            }
        } else if(call.method.elementsEqual("setDevMode")) {
            if let args = call.arguments as? Dictionary<String, Any>, let devMode = args["devMode"] as? Bool {
                showLog = devMode
                Airflex.setDevMode(devMode )
                result(true)
            } else {
                result(false)
            }
        } else if(call.method.elementsEqual("getDeepLink")) {
            checkDeepLink()
            if let appDelegate = UIApplication.shared.delegate as? FlutterAppDelegate {
                if let userActivity = appDelegate.userActivity, userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL {
                    handleDeeplink(url: url.absoluteString)
                }
            }
        } else if(call.method.elementsEqual("event")) {
            if let args = call.arguments as? Dictionary<String, Any>, let event = args["eventName"] as? String {
                print(event)
                if let data = args["data"] as? [String: Any] {
                    Airflex.logEvent(name: event, data: data)
                } else {
                    Airflex.logEvent(name: event, data: nil)
                }
                result(true)
            } else {
                result(false)
            }
        } else if(call.method.elementsEqual("setUserInfo")) {
            if let args = call.arguments as? Dictionary<String, Any>, let data = args["data"] as? [String: Any] {
                print(data)
                let userInfo = UserInfo.fromDictionary(data: data)
                Airflex.setUserInfo(userInfo: userInfo)
                result(true)
            } else {
                result(false)
            }
        } else if(call.method.elementsEqual("setCurrentScreen")) {
            if let args = call.arguments as? Dictionary<String, Any>, let screenName = args["screenName"] as? String {
                print(screenName)
                Airflex.setCurrentScreen(screenName)
                result(true)
            } else {
                result(false)
            }
        } else if(call.method.elementsEqual("setRevenue")) {
            if let args = call.arguments as? Dictionary<String, Any>, let orderId = args["orderId"] as? String, let amount = args["amount"] as? Double, let currency = args["currency"] as? String, let data = args["data"] as? [String: Any] {
                Airflex.setRevenue(orderId: orderId, amount: amount, currency: currency, data: data)
                result(true)
            } else {
                result(false)
            }
        } else if(call.method.elementsEqual("setProductList")) {
            if let args = call.arguments as? Dictionary<String, Any>, let listName = args["listName"] as? String, let products = args["products"] as? [[String: Any]] {
                let productsList = ProductItem.fromList(products)
                Airflex.setProductList(listName: listName, products: productsList)
            }
        } else if(call.method.elementsEqual("createLink")) {
            if let args = call.arguments as? Dictionary<String, Any>, let params = args["params"] as? [String: Any] {
                let linkBuider = DeepLinkBuilder()
                linkBuider.createLink(with: params) { resultData, errorData in
                    if (errorData != nil) {
                        result([
                            "success": false,
                            "messsage": errorData?.message ?? ""
                        ] as [String : Any])
                    } else if(resultData != nil && resultData?.shortLink.isEmpty == false) {
                        result([
                            "success": true,
                            "messsage": "Success",
                            "longLink": resultData?.longLink ?? "",
                            "shortLink": resultData?.shortLink ?? "",
                            "qrLink": resultData?.qrLink ?? "",
                        ] as [String : Any])
                    } else {
                        result([
                            "success": false,
                            "messsage": "Cannot create link"
                        ] as [String : Any])
                    }
                }
            } else {
                result([
                    "success": false,
                    "messsage": "Cannot create link without params"
                ] as [String : Any])
            }
        } else if(call.method.elementsEqual("getAd")) {
            if let args = call.arguments as? Dictionary<String, Any>, let adId = args["adId"] as? String, let adType = args["adType"] as? String {
                AirflexAdHelper.getAd(adId: adId, adType: adType) { adItem in
                    if let adItem = adItem as AdItem? {
                        result([
                            "success": true,
                            "adItem": adItem.toJsonString() ?? "",
                            "message": "Success"
                        ])
                    } else {
                        result([
                            "success": false,
                            "adItem": nil,
                            "message": "Cannot get ad"
                        ])
                    }
                }
            } else {
                result([
                    "success": false,
                    "adItem": nil,
                    "message": "Cannot get ad without params"
                ])
            }
        } else if(call.method.elementsEqual("trackAdClick")) {
            if let args = call.arguments as? Dictionary<String, Any>, let adId = args["adId"] as? String, let productId = args["productId"] as? String {
                AirflexAdHelper.trackClick(adId: adId, productId: productId)
                result(true)
            } else {
                result(false)
            }
        } else if(call.method.elementsEqual("trackAdImpression")) {
            if let args = call.arguments as? Dictionary<String, Any>, let adId = args["adId"] as? String, let productId = args["productId"] as? String {
                AirflexAdHelper.trackImpression(adId: adId, productId: productId)
                result(true)
            } else {
                result(false)
            }
        } else if(call.method.elementsEqual("createShortLink")) {
            if let args = call.arguments as? Dictionary<String, Any>, let longLink = args["longLink"] as? String {
                let name: String? = args["name"] as? String? ?? ""
                let shortLinkId: String? = args["shortLinkId"] as? String? ?? ""
                let linkBuider = DeepLinkBuilder()
                linkBuider.createShortLink(longLink: longLink, name: name ?? "", shortLinkId: shortLinkId ?? "") { resultData, errorData in
                    if (errorData != nil) {
                        result([
                            "success": false,
                            "message": errorData?.message ?? ""
                        ] as [String : Any])
                    } else if(resultData != nil && resultData?.shortLink.isEmpty == false) {
                        result([
                            "success": true,
                            "messsage": errorData?.message ?? "",
                            "longLink": resultData?.longLink ?? "",
                            "shortLink": resultData?.shortLink ?? "",
                            "qrLink": resultData?.qrLink ?? "",
                        ] as [String : Any])
                    } else {
                        result([
                            "success": false,
                            "message": "Có lỗi xảy ra trong quá trình xử lý"
                        ] as [String : Any])
                    }
                }
            }
        }
    }
    
    
    private func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let url = launchOptions?[UIApplication.LaunchOptionsKey.url] as? URL {
            handleDeeplink(url: url.absoluteString)
        }
        return true
    }

    public func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        handleDeeplink(url: url.absoluteString)
        return true
    }
    
    private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL {
            handleDeeplink(url: url.absoluteString)
        }
        return true
    }

    private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL {
            handleDeeplink(url: url.absoluteString)
        }
        return true
    }
    
    public func handleDeeplink(url: String) {
        if(url != "" && deeplink != url) {
            deeplink = url
            checkDeepLink()
        }
    }
}
