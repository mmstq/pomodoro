package com.mmstq.pomo.pomodoro

import android.content.Intent
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.util.*

class MainActivity: FlutterActivity() {

    private val METHOD_CHANNEL_NAME = "com.mmstq.pomodoro/method"
    private var methodChannel:MethodChannel? = null
    private var intent:Intent? = null


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        intent = Intent(this, NotificationService::class.java)
        setupChannels(flutterEngine.dartExecutor.binaryMessenger)

    }

    private fun setupChannels(messenger: BinaryMessenger) {

        methodChannel = MethodChannel(messenger, METHOD_CHANNEL_NAME)
        methodChannel!!.setMethodCallHandler{ call, result ->

            when (call.method) {
                "startService" -> {
                    startNotificationService()
                    result.success(listOf("Successfully Started"))

                }
                "stopService" -> {
                    stopService()
                    result.success(listOf("Successfully Stopped"))
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    private fun startNotificationService() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent)
        }else{
            startService(intent)
        }
    }

    private fun stopService(){
        stopService(intent);
    }

}
