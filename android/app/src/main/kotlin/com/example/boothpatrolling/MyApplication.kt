package com.application.boothpatrolling


import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import io.flutter.app.FlutterApplication;
class MyApplication : FlutterApplication(){
    override fun onCreate() {
        super.onCreate()
        if(Build.VERSION.SDK_INT>= Build.VERSION_CODES.O){
            val channel = NotificationChannel("boothpatrolling/Notification","Location Foreground Service",NotificationManager.IMPORTANCE_DEFAULT)
            val manager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(channel)

        }
    }
}