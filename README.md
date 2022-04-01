# Flutter sample app

> Instructions for the billers to integrate sdk in Flutter.

## Table of contents
* Android
    * Compatiblility
    * Setup
    * Usage
* iOS
    * Compatiblility
    * Setup
    * Usage
* Contact
# Android

## Compatiblility
- Support from android version 5+ (Android sdk 21+)

## Setup
* **First Step**

Download bill24 sdk.

* **Second Step**

Find libs folder in your app directory or create new one if you could not find libs folder and drag bill24 sdk with aar file extention
to this folder

* **Third Step**

Add require dependencies in app/build.gradle:
```gradle
dependencies {

    //Bill24 Android SDK and require dependencies
    api 'com.google.android.material:material:1.4.0'
    api files('libs/bill24sdk.aar')
    api 'com.github.zcweng:switch-button:0.0.3@aar'
    api("com.squareup.okhttp3:okhttp:4.9.3")
    api 'com.github.bumptech.glide:glide:4.12.0'
    annotationProcessor 'com.github.bumptech.glide:compiler:4.12.0'
    api ('io.socket:socket.io-client:2.0.1') {
        // excluding org.json which is provided by Android
        exclude group: 'org.json', module: 'json'
    }
    api 'com.marozzi.roundbutton:round-button:1.0.7'

    }
```
* **Forth Step**

Change kotlin version to 1.6.0 and add these dependencies in android/build.gradle:
```gradle
dependencies {
        classpath 'com.android.tools.build:gradle:4.1.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:1.6.0"
    }
```
## Usage

In dart file (same for iOS):

**Dart**
```dart

  static const platform = const MethodChannel('bill24Sdk');
  var language = "en";
  var switchValue = false;

  Future<dynamic> getSessionId() async {
    const clientId = "fmDJiZyehRgEbBJTkXc7AQ==";
    const url = "http://203.217.169.102:50209";
    Map<String, String> mainheader = {
      "accept": "application/json",
      "Content-type": "application/json",
      "Authorization":
          "Bearer eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJQYXltZW50R2F0ZXdheSIsInN1YiI6IkVEQyIsImhhc2giOiJCQ0ZEQzE1MC0zMjRGLTQzRjQtQkQ3Qi0zMTVGN0Y5NDM3NDAifQ.OZ9AqnbRucNmVlJzQt6kqkRjDDDPjMAN81caYwqKuX4",
    };
    var payload =
    {
    "customer": {
    "customer_ref": "C00001",
    "customer_email": "example@gmail.com",
    "customer_phone": "010801252",
    "customer_name": "test customer"
    },
    "billing_address": {
    "province": "Phnom Penh",
    "country": "Cambodia",
    "address_line_2": "string",
    "postal_code": "12000",
    "address_line_1": "No.01, St.01, Toul Kork"
    },
    "description": "Extra note",
    "language": "km",
    "order_items": [
    {
    "item_ref": "001",
    "amount": 10
    }
    ],
    "payment_success_url": "/payment/success",
    "currency": "USD",
    "amount": 1,
    "pay_later_url": "/payment/paylater",
    "shipping_address": {
    "province": "Phnom Penh",
    "country": "Cambodia",
    "address_line_2": "string",
    "postal_code": "12000",
    "address_line_1": "No.01, St.01, Toul Kork"
    },
    "order_ref":"RamdomString",
    "payment_fail_url": "payment/fail",
    "payment_cancel_url": "payment/cancel",
    "continue_shopping_url": "http://localhost:8090/order"
    };
    final response = await http.post(Uri.parse(url + "/order/create/v1"),
        body: json.encoder.convert(payload), headers: mainheader);
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  void callSdk() async {
    var value;
    List<String> arguments = [];
    try {
      getSessionId().then((result) async {
        if (result["code"] == "000") {
          if (switchValue == true) {
            language = "kh";
            arguments.add(result["data"]["session_id"]);
            arguments.add(language);
          }
          else{
            language = "en";
            arguments.add(result["data"]["session_id"]);
            arguments.add(language);
          }
          value = await platform.invokeMethod(
              "bill24Sdk", arguments);
          if (value.isNotEmpty) {
            var tranData;
            if(Platform.isAndroid) {
              print((json.decode(value))[0]["tran_data"]);
              tranData = (json.decode(value))[0]["tran_data"];
            }
            else{
              tranData = value["tran_data"];
            }


            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PaymentSucceeded(
                        tranData["order_ref"].toString(),
                        tranData["bank_name_en"].toString(),
                        tranData["bank_ref"].toString(),
                        tranData["trans_id"].toString(),
                        tranData["status"].toString())));
          }
        } else {
          return;
        }
      });

      const sample_response = """
      ["tran_data": {
      "bank_name_en" = ACLEDA;
      "bank_name_kh" = "\U17a2\U17c1\U179f\U17ca\U17b8\U179b\U17b8\U178a\U17b6";
      "bank_ref" = FT220840WCB4789H;
      "order_ref" = "Optional(123124)";
      status = 0;
      "trans_id" = 9wzcLMPS;
      }, "payment_success_url": /payment/success]
      """;
    } catch (e) {
      print(e);
    }
  }
```

In Android folder, find file MainActivity.kt and paste these:

**Kotlin**
```kotlin
package com.example.flutter_sample_app

import io.flutter.embedding.android.FlutterActivity

import io.flutter.embedding.engine.FlutterEngine

import io.flutter.plugin.common.MethodChannel
import java.util.*
import com.example.bill24sk.bottomSheetController

import io.flutter.embedding.android.FlutterFragmentActivity


class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "bill24Sdk"
    private lateinit var channel: MethodChannel
    lateinit var sessionId:String
    val token:String = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJQYXltZW50R2F0ZXdheSIsInN1YiI6IkVEQyIsImhhc2giOiJCQ0ZEQzE1MC0zMjRGLTQzRjQtQkQ3Qi0zMTVGN0Y5NDM3NDAifQ.OZ9AqnbRucNmVlJzQt6kqkRjDDDPjMAN81caYwqKuX4"
    val url:String = "http://203.217.169.102:50209"
    val clientId:String = "fmDJiZyehRgEbBJTkXc7AQ=="
    // environment must be either "uat" or "prod" only
    val environment:String = "uat"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler { call, result ->

            if(call.method == "bill24Sdk") {
                    var arguments = call.arguments as ArrayList<String>

                    val bottomsheetFrag = bottomSheetController(supportFragmentManager = supportFragmentManager,
                        sessionId = arguments[0],
                        clientID = clientId, activity = this
                        ,payment_succeeded = FlutterActivity(),language = arguments[1],continue_shopping =  FlutterActivity()
                        ,environment = environment){

                        result.success(Arrays.toString(it as Array<out Any>))
                    }

                    // to call sdk screen
                    bottomsheetFrag.show(supportFragmentManager,"")
            }
        }
    }

}

```

Where:
* **getSupportFragmentManager** or **supportFragmentManager** can be get from the activity
* **pay_later()** is activity which will be navigated to, when user choose pay later option
* **sessionId** is the string which get from checkout response
* **clientID** is the string given by bill24 to the biller
* **activity** is the current activity
* **language** is the string that specify the language. Language can be "en" or "kh" only.
* **environment** is the environment that you want to use. Environtment can be "uat" or "prod" only.

# iOS

## Compatiblility
- Support from iOS version 11+ .

## Setup
* **Step 1**

Download bill24 sdk.

* **Step 2**

Extract the zip and you will get bill24Sdk.framework

![step 2](https://github.com/S-Vivorth/Project-For-IOS-SDK/blob/master/img/Screen%20Shot%202022-01-25%20at%203.29.34%20PM.jpg?raw=true)

* **Step 3**

In Flutter, go to ios folder and open Runner.xcworkspace

* **Step 4**

Drag bill24sdk.framework into your project.

![step 4](https://github.com/S-Vivorth/Project-For-IOS-SDK/blob/master/img/Screen%20Shot%202022-01-25%20at%203.08.17%20PM.jpg?raw=true)


![step 4](https://github.com/S-Vivorth/Project-For-IOS-SDK/blob/master/img/Screen%20Shot%202022-01-25%20at%203.44.58%20PM.jpg?raw=true)


* **Step 5**

Make sure you link framework in frameworks section and link binary with libraries section.

![step 5](https://github.com/S-Vivorth/Project-For-IOS-SDK/blob/master/img/Screen%20Shot%202022-01-25%20at%203.09.02%20PM.jpg?raw=true)


![step 5](https://github.com/S-Vivorth/Project-For-IOS-SDK/blob/master/img/Screen%20Shot%202022-01-25%20at%203.09.24%20PM.jpg?raw=true)


* **Step 5**

Add required cocoapods in podfile:
```gradle
    	pod 'Alamofire', '5.4'
	pod 'CryptoSwift', '1.4.1'
	pod 'Socket.IO-Client-Swift'
```

## Usage

In Runner.xcworkspace, open AppDelegate.swift file and paste:

**Swift**
```swift
import UIKit
import Flutter
import bill24Sdk
import Alamofire
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var orderRef:String!

    // language must be either "en" or "kh" only
    var language:String = "kh"

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
      let channel = FlutterMethodChannel(name: "bill24Sdk",binaryMessenger: controller.binaryMessenger)
      channel.setMethodCallHandler({
          [weak self] (call: FlutterMethodCall, results: @escaping (Any)->Void) -> Void in
          if(call.method == "bill24Sdk") {
              print("hello from ios")
              let arguments = call.arguments as! Array<String>
              let controller : FlutterViewController = self!.window?.rootViewController as! FlutterViewController

                    self?.window.rootViewController?.dismiss(animated: true, completion: {
                        BottomSheetAnimation().openSdk(controller: controller,sessionID: arguments[0], cliendID: self!.clientId,language: arguments[1],environment: self!.environment){order_details in

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

```


Where:
* **controller** is current UIViewController
* **sessionID** can be get from checkout api response above
* **clientID** is unique id for biller
* **language** is the string that specify the language. Language can be "en" or "kh" only.
* **environment** is the environment that you want to use
* **initPayLater** is a required empty function
* **initSuccess** is a required empty function

In payment succeeded screen, to verify transaction you have to:

```dart
          Future<dynamic> transVerify() async{
    const String url = "http://203.217.169.102:50209/transaction/verify/v1";
    Map<String, String> mainheader = {
      "accept" : "application/json",
      "Content-type": "application/json",
      "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJQYXltZW50R2F0ZXdheSIsInN1YiI6IkVEQyIsImhhc2giOiJCQ0ZEQzE1MC0zMjRGLTQzRjQtQkQ3Qi0zMTVGN0Y5NDM3NDAifQ.OZ9AqnbRucNmVlJzQt6kqkRjDDDPjMAN81caYwqKuX4",
    };

    final response = await http.post(Uri.parse(url),headers: mainheader,body: json.encoder.convert(
        {"tran_id": transId}));

    return json.decode(response.body);
  }
```


Congratulations, you are ready to use the SDK.

For more detail of integration please take a look at the sample project.

## Contact
Created by
[@bill24 team](https://t.me/Vivorth_San) - feel free to contact me!















