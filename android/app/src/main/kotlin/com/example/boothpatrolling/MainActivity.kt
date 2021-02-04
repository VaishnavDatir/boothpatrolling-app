package com.application.boothpatrolling


import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
//    private var forService: Intent? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

//        this.forService = Intent(this@MainActivity, MyService::class.java)

        val binaryMessenger = flutterEngine?.dartExecutor?.binaryMessenger
        MethodChannel(binaryMessenger, "com.androidv.BoothPatrolling/Start")
                .setMethodCallHandler { call, result ->
                    if (call.method.equals("startService")) {
                        Log.i("Starting SERVICE", "SERVICE Starting")

//                        startService(forService)
                        val callbackRawHandle = call.arguments as Long
                        MyService.startMyService(this@MainActivity, callbackRawHandle)
//                        result.success("Service Started");
                        Log.i("Starting SERVICE", "SERVICE Started")

                    }
                }
        MethodChannel(binaryMessenger, "com.androidv.BoothPatrolling/Stop")
                .setMethodCallHandler { call, result ->
                    if (call.method == "stopService") {
                        Log.i("STOP SERVICE", "STOPPING SERVICE")
//                        val callbackRawHandle = call.arguments as Double
                        MyService.stopMyService(this@MainActivity) /*,callbackRawHandle)*/
                        Log.i("STOP SERVICE", "SERVICE Stopped")
//                        result.success("Service stoped");
                    }
                }

        MethodChannel(binaryMessenger,"com.androidv.BoothPatrolling/app_retain").apply {
            setMethodCallHandler { call, result -> if (call.method == "sendToBackground"){
                moveTaskToBack(true)
            }
            }
        }
    }
    override fun onDestroy() {
        super.onDestroy()
        MyService.stopMyService(this@MainActivity)
    }
}
