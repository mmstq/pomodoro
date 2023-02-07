package com.mmstq.pomo.pomodoro

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.os.PersistableBundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterView
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        GeneratedPluginRegistrant.registerWith(this)
        MethodChannel(flutterView, "messages").setMethodCallHandler {
            call, resutl ->
                if (call.method == "start"){
                    print("hello")
                }
        }
    }



    fun startNotificationService() {
        val intent = Intent(this, NotificationService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent)
        }else{
            startService(intent)
        }
    }

}
