package com.lqy.word_clock

import android.app.*
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.drawable.Icon
import android.os.Build
import android.os.IBinder
import android.util.Log


class ClockService : Service() {

    private val mReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            when (intent.action) {
                Intent.ACTION_SCREEN_ON -> screenOn(context)
                Intent.ACTION_SCREEN_OFF -> screenOff(context)
            }
        }
    }

    private fun screenOn(context: Context) {
    }

    private fun screenOff(context: Context) {
        val intent = Intent(context, MainActivity::class.java)
        intent.addFlags(Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(intent)
    }

    private fun register() {
        val filters = IntentFilter().apply {
            addAction(Intent.ACTION_SCREEN_ON)
            addAction(Intent.ACTION_SCREEN_OFF)
        }
        registerReceiver(mReceiver, filters)
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        initialNotification()
        if (isLock()) {
            cancelLock()
        }
        register()
        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(mReceiver)
    }

    private fun cancelLock() {
        try {
            val km = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
            val keyguardLock = km.newKeyguardLock("")
            keyguardLock.disableKeyguard()
        } catch (e: Exception) {

        }
    }

    private fun isLock(): Boolean {
        return if (Build.VERSION.SDK_INT > 16) {
            (getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager).isKeyguardSecure
        } else {
            try {
                val clazz = Class.forName("com.android.internal.widget.LockPatternUtils")
                val constructor = clazz.getConstructor(Context::class.java)
                constructor.isAccessible = true
                val utils = constructor.newInstance(this)
                val method = clazz.getMethod("isSecure")
                method.invoke(utils) as Boolean
            } catch (e: Exception) {
                false
            }
        }
    }

    private fun initialNotification() {
        val intent = Intent()
        val notification: Notification
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            val channel = NotificationChannel(packageName, "word clock", NotificationManager.IMPORTANCE_LOW);
            notificationManager.createNotificationChannel(channel)
            notification = Notification.Builder(this, packageName)
                    .setContentTitle("word clock")
                    .setOngoing(true)
                    .setSmallIcon(R.mipmap.ic_launcher)
                    .setLargeIcon(Icon.createWithResource(this, R.mipmap.ic_launcher))
                    .setContentIntent(PendingIntent.getBroadcast(applicationContext, 0, intent, 0))
                    .build()
        } else {
            val notificationBuilder = Notification.Builder(this)
                    .setContentIntent(PendingIntent.getBroadcast(applicationContext, 0, intent, 0))
                    .setContentTitle("word clock")
                    .setSmallIcon(R.mipmap.ic_launcher)
                    .setOngoing(true)
            notification = notificationBuilder.build()
        }
        startForeground(100, notification)
    }
} 