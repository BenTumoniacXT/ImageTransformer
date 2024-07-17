import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let onnxChannel = FlutterMethodChannel(
      name: "ort",
      binaryMessenger: controller.binaryMessenger
    )

    onnxChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: FlutterResult) -> Void in
      // This method is invoked on the UI thread.
      switch call.method {
        case "decode":
          let args = call.arguments as? Dictionary<String, Any>
          result(ONNXProcessor.decodeImg(inputData: args!["inputData"] as? [[[[Double]]]]))
          
        default:
          result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}