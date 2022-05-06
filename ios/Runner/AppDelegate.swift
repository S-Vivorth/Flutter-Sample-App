import UIKit
import Flutter
import bill24Sdk
import Alamofire
import Starscream
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    enum NetworkError: Error {
        case unauthorised
        case timeout
        case serverError
        case invalidResponse
    }
    var orderRef:String!
    
    // language must be either "en" or "kh" only
    
    
    // environment must be either "uat" or "prod" only
    let environment:String = "uat"
    
    // clientId can be obtained from bill24
    let clientId:String = "fmDJiZyehRgEbBJTkXc7AQ=="
    
    // this url can be obtained from bill24
    let url:String = "http://203.217.169.102:50209"
    let token:String = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJQYXltZW50R2F0ZXdheSIsInN1YiI6IkVEQyIsImhhc2giOiJCQ0ZEQzE1MC0zMjRGLTQzRjQtQkQ3Qi0zMTVGN0Y5NDM3NDAifQ.OZ9AqnbRucNmVlJzQt6kqkRjDDDPjMAN81caYwqKuX4"
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
      let channel = FlutterMethodChannel(name: "paymentSdk",binaryMessenger: controller.binaryMessenger)
      channel.setMethodCallHandler({
          [weak self] (call: FlutterMethodCall, results: @escaping (Any)->Void) -> Void in
          if(call.method == "paymentSdk") {
              let arguments = call.arguments as! [String: String]
              let sessionID : String? = arguments["session_id"]
              let language : String? = arguments["language"]
              let theme_mode: String? = arguments["theme_mode"]
              let controller : FlutterViewController = self!.window?.rootViewController as! FlutterViewController
                    
                    self?.window.rootViewController?.dismiss(animated: true, completion: {
                        paymentSdk().openSdk(controller: controller,sessionID: sessionID ?? "", cliendID: self!.clientId,language: language ?? "en",environment: self!.environment, theme_mode: theme_mode ?? ""){order_details in
                      
                      results(order_details)
                        
                      self?.initPayLater(dict: order_details)
                  } initPaySuccess: { order_details in
                      self!.initSuccess(dict: order_details)
                      results(order_details)

                  }
              })
          }
      })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
   
    
    
    func initSuccess(dict:[String:Any])
    {
           }
    
    func initPayLater( dict:[String:Any]){

    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    
}
