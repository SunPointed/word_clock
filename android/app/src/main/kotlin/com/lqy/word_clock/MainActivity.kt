package com.lqy.word_clock

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.Color
import android.os.Build
import android.os.Bundle
import android.view.View.*
import android.view.WindowManager
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "com.lqy.word_clock/sp"
        const val SCORE = "SCORE"
        const val SHIFT = "SHIFT"
        const val CIRCLE = "CIRCLE"
        const val BACKGROUND_COLOR = "BACKGROUND_COLOR"
        const val BACK_TEXT_COLOR = "BACK_TEXT_COLOR"
        const val TEXT_COLOR = "TEXT_COLOR"
    }

    private val mReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            when (intent.action) {
                Intent.ACTION_USER_PRESENT -> screenUser(context)
                "$packageName close" -> {
                    finish()
                }
            }
        }
    }

    private fun screenUser(context: Context) {
        goHome()
    }

    private fun register() {
        val filters = IntentFilter().apply {
            addAction(Intent.ACTION_USER_PRESENT)
            addAction("$packageName close")
        }
        registerReceiver(mReceiver, filters)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
        } else {
            window.addFlags(WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD
                    or WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            window.navigationBarColor = Color.BLACK
        }
        super.onCreate(savedInstanceState)
        Util.hideSystemUI(this)
        register()
        GeneratedPluginRegistrant.registerWith(this)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            window.decorView.setOnSystemUiVisibilityChangeListener {
                if ((it and SYSTEM_UI_FLAG_FULLSCREEN) == 0) {
                    Util.hideSystemUI(this)
                }
            }
        }
        initChannel()
    }

    private fun initChannel() {
        MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getSpSetting") {
                val sp = getSharedPreferences(packageName, Context.MODE_PRIVATE)
                result.success(mutableListOf<Any>().apply {
                    add(sp.getBoolean(SCORE, true))
                    add(sp.getBoolean(SHIFT, true))
                    add(sp.getBoolean(CIRCLE, true))
                    add(sp.getInt(BACKGROUND_COLOR, 0xff000000.toInt()))
                    add(sp.getInt(BACK_TEXT_COLOR, 0x88ffffff.toInt()))
                    add(sp.getInt(TEXT_COLOR, 0xffffffff.toInt()))
                })
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        Util.hideSystemUI(this)
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(mReceiver)
    }

    override fun onBackPressed() {
        goHome()
    }

    private fun goHome() {
        moveTaskToBack(true)
    }


}
