package com.lqy.word_clock

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import com.afollestad.materialdialogs.MaterialDialog
import com.flask.colorpicker.builder.ColorPickerClickListener
import com.lqy.word_clock.MainActivity.Companion.BACKGROUND_COLOR
import com.lqy.word_clock.MainActivity.Companion.BACK_TEXT_COLOR
import com.lqy.word_clock.MainActivity.Companion.CIRCLE
import com.lqy.word_clock.MainActivity.Companion.SCORE
import com.lqy.word_clock.MainActivity.Companion.SHIFT
import com.lqy.word_clock.MainActivity.Companion.TEXT_COLOR
import com.lqy.word_clock.back.BackUtil
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
            finish()
        }

        val sp = getSharedPreferences(packageName, Context.MODE_PRIVATE)

        if (sp.getBoolean("initial", true)) {
            sp.edit().run {
                putBoolean("initial", false)
                putBoolean(SCORE, true)
                putBoolean(SHIFT, true)
                putBoolean(CIRCLE, true)
                putInt(BACKGROUND_COLOR, 0xff000000.toInt())
                putInt(BACK_TEXT_COLOR, 0x88ffffff.toInt())
                putInt(TEXT_COLOR, 0xffffffff.toInt())
                commit()
            }
        }

        val isCircle = sp.getBoolean(CIRCLE, true)
        val isShift = sp.getBoolean(SHIFT, true)
        val isScore = sp.getBoolean(SCORE, true)

        cb_circle.isChecked = isCircle
        cb_shift.isChecked = isShift
        cb_score.isChecked = isScore

        btn_back_color.setOnClickListener {
            val initialColor = sp.getInt(BACKGROUND_COLOR, 0xff000000.toInt())
            ColorUtil.showColorChooseDialog(
                    this,
                    initialColor,
                    colorPickerClickListener = ColorPickerClickListener { _, lastSelectedColor, _ ->
                        sp.edit().run {
                            putInt(BACKGROUND_COLOR, lastSelectedColor)
                            commit()
                        }
                        sendBroadcast(Intent("$packageName close"))
                    })
        }

        btn_default_time_color.setOnClickListener {
            val initialColor = sp.getInt(BACK_TEXT_COLOR, 0x88ffffff.toInt())
            ColorUtil.showColorChooseDialog(
                    this,
                    initialColor,
                    colorPickerClickListener = ColorPickerClickListener { _, lastSelectedColor, _ ->
                        sp.edit().run {
                            putInt(BACK_TEXT_COLOR, lastSelectedColor)
                            commit()
                        }
                        sendBroadcast(Intent("$packageName close"))
                    })
        }

        btn_cur_time_color.setOnClickListener {
            val initialColor = sp.getInt(TEXT_COLOR, 0xffffffff.toInt())
            ColorUtil.showColorChooseDialog(
                    this,
                    initialColor,
                    colorPickerClickListener = ColorPickerClickListener { _, lastSelectedColor, _ ->
                        sp.edit().run {
                            putInt(TEXT_COLOR, lastSelectedColor)
                            commit()
                        }
                        sendBroadcast(Intent("$packageName close"))
                    })
        }

        cb_score.setOnCheckedChangeListener { _, isChecked ->
            sp.edit().putBoolean(SCORE, isChecked).commit()
        }
        cb_shift.setOnCheckedChangeListener { _, isChecked ->
            sp.edit().putBoolean(SHIFT, isChecked).commit()
        }
        cb_circle.setOnCheckedChangeListener { _, isChecked ->
            sp.edit().putBoolean(CIRCLE, isChecked).commit()
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            cb_circle.post {
                if (!BackUtil.isIgnoringBatteryOptimizations(this)) {
                    MaterialDialog(this).apply {
                        title(res = R.string.permission_request)
                        message(res = R.string.permission_request_hint)
                        negativeButton(res = R.string.reject)
                        cancelOnTouchOutside(false)
                        positiveButton(res = R.string.confirm, click = {
                            BackUtil.requestIgnoreBatteryOptimizations(this@SettingActivity)
                        })
                        show()
                    }
                }
            }
        }
    }
}