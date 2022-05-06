package com.example.flutter_sample_app

import io.flutter.embedding.android.FlutterActivity

import io.flutter.embedding.engine.FlutterEngine

import io.flutter.plugin.common.MethodChannel
import java.util.*
import com.bill24.paymentSdk.paymentSdk

import io.flutter.embedding.android.FlutterFragmentActivity


class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "paymentSdk"
    private lateinit var channel: MethodChannel
    val clientId:String = "fmDJiZyehRgEbBJTkXc7AQ=="
    // environment must be either "uat" or "prod" only
    val environment:String = "uat"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler { call, result ->

            if(call.method == "paymentSdk") {
                    val arguments = call.arguments as Map<String, String>
                    val sessionId: String = arguments["session_id"].toString()
                    val language: String = arguments["language"].toString()
                    val theme_mode: String = arguments["theme_mode"].toString()
                    val paymentSdk = paymentSdk(supportFragmentManager = supportFragmentManager,
                        sessionId = sessionId,
                        clientID = clientId, activity = this
                        ,payment_succeeded = FlutterActivity(),language = language,continue_shopping =  FlutterActivity()
                        ,environment = environment,theme_mode = theme_mode){

                        result.success(Arrays.toString(it as Array<out Any>))
                    }

                    // to call sdk screen
                    paymentSdk.show(supportFragmentManager,"")
            }
        }
    }
}
