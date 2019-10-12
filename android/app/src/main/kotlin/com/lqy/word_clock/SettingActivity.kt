package com.lqy.word_clock

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Bundle
import com.lqy.word_clock.MainActivity.Companion.CIRCLE
import com.lqy.word_clock.MainActivity.Companion.SCORE
import com.lqy.word_clock.MainActivity.Companion.SHIFT
import kotlinx.android.synthetic.main.a_setting.*


class SettingActivity : Activity() {

//    val mSp = getSharedPreferences()

    @SuppressLint("ApplySharedPref")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.a_setting)
        btn.setOnClickListener {
            startService(Intent(this, ClockService::class.java))
            finish()
        }
        btn_clock.setOnClickListener {
            startActivity(Intent(this, MainActivity::class.java))
        }
        btn_close.setOnClickListener {
            stopService(Intent(this, ClockService::class.java))
            sendBroadcast(Intent("$packageName close"))
        }

        val sp = getSharedPreferences(packageName, Context.MODE_PRIVATE)

        if (sp.getBoolean("initial", true)) {
            sp.edit().run {
                putBoolean("initial", false)
                putBoolean(SCORE, true)
                putBoolean(SHIFT, true)
                putBoolean(CIRCLE, true)
                commit()
            }
        }

        val isCircle = sp.getBoolean(CIRCLE, true)
        val isShift = sp.getBoolean(SHIFT, true)
        val isScore = sp.getBoolean(SCORE, true)

        cb_circle.isChecked = isCircle
        cb_shift.isChecked = isShift
        cb_score.isChecked = isScore

        cb_score.setOnCheckedChangeListener { _, isChecked ->
            sp.edit().putBoolean(SCORE, isChecked).commit()
        }
        cb_shift.setOnCheckedChangeListener { _, isChecked ->
            sp.edit().putBoolean(SHIFT, isChecked).commit()
        }
        cb_circle.setOnCheckedChangeListener { _, isChecked ->
            sp.edit().putBoolean(CIRCLE, isChecked).commit()
        }
    }
}