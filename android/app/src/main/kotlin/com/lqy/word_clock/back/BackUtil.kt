package com.lqy.word_clock.back

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import androidx.annotation.RequiresApi

object BackUtil {
    @RequiresApi(api = Build.VERSION_CODES.M)
    fun isIgnoringBatteryOptimizations(context: Context): Boolean {
        var isIgnoring = false
        (context.getSystemService(Context.POWER_SERVICE) as PowerManager).run {
            isIgnoring = isIgnoringBatteryOptimizations(context.packageName)
        }
        return isIgnoring;
    }

    @SuppressLint("BatteryLife")
    @RequiresApi(api = Build.VERSION_CODES.M)
    fun requestIgnoreBatteryOptimizations(context: Context) {
        try {
            context.startActivity(Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                data = Uri.parse("package:" + context.packageName)
            })
        } catch (e: Exception) {
            e.printStackTrace();
        }
    }
}