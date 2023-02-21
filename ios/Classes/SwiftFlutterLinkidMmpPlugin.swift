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
    result("iOS " + UIDevice.current.systemVersion)
  }
}
