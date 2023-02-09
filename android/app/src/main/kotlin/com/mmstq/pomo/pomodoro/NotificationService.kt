package com.mmstq.pomo.pomodoro

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

class NotificationService : Service() {

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            println("hello")

            val channel = NotificationChannel(
                "messages",
                "messages",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            val notificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
            val builder = NotificationCompat.Builder(this, "messages")
                .setContentTitle("textTitle")
                .setContentText("textContent")
                .setOngoing(true)
            startForeground(101, builder.build())
        }
        return super.onStartCommand(intent, flags, startId)
    }

    override fun onBind(p0: Intent?): IBinder? {
        return null

    }
}