package com.lqy.word_clock

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.Color
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.View.*
import android.view.WindowManager
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "com.lqy.word_clock/sp"
        const val SCORE = "SCORE"
        const val SHIFT = "SHIFT"
        const val CIRCLE = "CIRCLE"
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
        Utils.hideSystemUI(this)
        register()
        GeneratedPluginRegistrant.registerWith(this)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            window.decorView.setOnSystemUiVisibilityChangeListener {
                if ((it and SYSTEM_UI_FLAG_FULLSCREEN) == 0) {
                    window.decorView.systemUiVisibility = (SYSTEM_UI_FLAG_LAYOUT_STABLE
                            or SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                            or SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                            or SYSTEM_UI_FLAG_HIDE_NAVIGATION
                            or SYSTEM_UI_FLAG_FULLSCREEN
                            or SYSTEM_UI_FLAG_IMMERSIVE_STICKY)
                }
            }
        }
        initChannel()
    }

    private fun initChannel() {
        MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getSpSetting") {
                val sp = getSharedPreferences(packageName, Context.MODE_PRIVATE)
                result.success(mutableListOf<Boolean>().apply {
                    add(sp.getBoolean(SCORE, true))
                    add(sp.getBoolean(SHIFT, true))
                    add(sp.getBoolean(CIRCLE, true))
                })
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            window.decorView.systemUiVisibility = (SYSTEM_UI_FLAG_LAYOUT_STABLE
                    or SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                    or SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                    or SYSTEM_UI_FLAG_HIDE_NAVIGATION
                    or SYSTEM_UI_FLAG_FULLSCREEN
                    or SYSTEM_UI_FLAG_IMMERSIVE_STICKY)
        }
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
