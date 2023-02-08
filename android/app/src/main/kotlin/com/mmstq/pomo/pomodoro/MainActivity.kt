package com.mmstq.pomo.pomodoro

import android.content.Context
import android.content.Intent
import android.os.Build

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val METHOD_CHANNEL_NAME = "com.mmstq.pomodoro/method"
    private var methodChannel:MethodChannel? = null
    /*override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        GeneratedPluginRegistrant.registerWith(this)
        MethodChannel(flutterView, "messages").setMethodCallHandler {
            call, resutl ->
                if (call.method == "start"){
                    print("hello")
                }
        }
    }*/

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        setupChannels(this, flutterEngine.dartExecutor.binaryMessenger)

    }

    private fun setupChannels(context: Context, messenger: BinaryMessenger) {
        methodChannel = MethodChannel(messenger, METHOD_CHANNEL_NAME)
        methodChannel!!.setMethodCallHandler{ call, resut ->
            if (call.method == "startService"){
                print("start bro")
                val a = listOf(1,2,3)
                resut.success(a)
            }else{
                resut.notImplemented()
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
