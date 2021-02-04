package com.application.boothpatrolling

import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.view.FlutterCallbackInformation
import io.flutter.view.FlutterMain
import java.lang.invoke.MethodHandle

class MyService : Service() {
    var flutterMyEngine: FlutterEngine? = null

    override fun onCreate() {
        super.onCreate()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val nBuilder = NotificationCompat.Builder(this, "boothpatrolling/Notification")
                    .setContentText("Updating current location")
                    .setContentTitle("Background Location")
                    .setSmallIcon(R.drawable.notification)
                    .setColorized(true)
                    .setAutoCancel(true)
            startForeground(1, nBuilder.build())
//               startFlutterNativeView()           }
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
//        return super.onStartCommand(intent, flags, startId)
        intent?.getLongExtra(KEY_CALLBACK_RAW_HANDLE, -1)?.let { callbackRawHandle ->
            if (callbackRawHandle != -1L) setCallbackRawHandle(callbackRawHandle)
        }
        startFlutterNativeView()

        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
//        stopFlutterNativeView()
//        Log.i("STOP SERVICE", "Derstoring Service")
//        flutterMyEngine?.destroy()
//        flutterMyEngine = null
//        Log.i("BackgroundService", "Stopping FlutterEngine")
        // startFlutterNativeView()
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private fun startFlutterNativeView() {
        if (flutterMyEngine != null) return
        Log.i("BackgroundService", "Starting FlutterEngine")
        getCallbackRawHandle()?.let { callbackRawHandle ->
            flutterMyEngine = FlutterEngine(this).also { engine ->
                val callbackInformation =
                        FlutterCallbackInformation.lookupCallbackInformation(callbackRawHandle)

                engine.dartExecutor.executeDartCallback(
                        DartExecutor.DartCallback(
                                assets,
                                FlutterMain.findAppBundlePath(),
                                callbackInformation
                        )
                )
            }
        }
        Log.i("BackgroundService", "Started FlutterEngine")
    }

    fun stopFlutterNativeView() {
        Log.i("BackgroundService", "Stopping FlutterEngine")
        flutterMyEngine?.destroy()
        flutterMyEngine = null
    }

    private fun getCallbackRawHandle(): Long? {
        val prefs = getSharedPreferences(SHARED_PREFERENCES_NAME, Context.MODE_PRIVATE)
        val callbackRawHandle = prefs.getLong(KEY_CALLBACK_RAW_HANDLE, -1)
        return if (callbackRawHandle != -1L) callbackRawHandle else null
    }

    private fun setCallbackRawHandle(handle: Long) {
        val prefs = getSharedPreferences(SHARED_PREFERENCES_NAME, Context.MODE_PRIVATE)
        prefs.edit().putLong(KEY_CALLBACK_RAW_HANDLE, handle).apply()
    }

    companion object {
        private val SHARED_PREFERENCES_NAME = "com.example.locationTrial"

        private val KEY_CALLBACK_RAW_HANDLE = "callbackRawHandle"

        fun startMyService(context: Context, callbackRawHandle: Long) {
            val intent = Intent(context, MyService::class.java).apply {
                putExtra(KEY_CALLBACK_RAW_HANDLE, callbackRawHandle)
            }
            ContextCompat.startForegroundService(context, intent)
//            context.startService(intent)

        }

        fun stopMyService(context: Context/*,callbackRawHandle: Double*/) {
            context.stopService(Intent(context, MyService::class.java))
        }
    }
}