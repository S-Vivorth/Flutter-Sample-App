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
