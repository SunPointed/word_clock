package com.lqy.word_clock

import android.app.Activity
import android.content.Context
import android.graphics.drawable.Drawable
import android.os.Build
import android.view.View
import android.widget.Toast
import androidx.annotation.ColorRes
import androidx.annotation.DrawableRes
import androidx.annotation.StringRes
import androidx.core.content.ContextCompat
import com.flask.colorpicker.ColorPickerView
import com.flask.colorpicker.OnColorSelectedListener
import com.flask.colorpicker.builder.ColorPickerClickListener
import com.flask.colorpicker.builder.ColorPickerDialogBuilder
import kotlin.math.ceil


object Util {
    fun getStatusBarHeight(context: Context): Int {
        var result = 0
        val resourceId = context.resources.getIdentifier("status_bar_height", "dimen", "android")
        if (resourceId > 0) {
            result = context.resources.getDimensionPixelSize(resourceId)
        }
        if (result == 0) {
            result = getStatusBarHeightPrivate(context).toInt()
        }
        return result
    }


    private fun getStatusBarHeightPrivate(context: Context): Double {
        return ceil(25.0 * context.resources.displayMetrics.density)
    }

    // This snippet hides the system bars.
    fun hideSystemUI(activity: Activity) {
        // Set the IMMERSIVE flag.
        // Set the content to appear under the system bars so that the content
        // doesn't resize when the system bars hide and show.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            activity.window.decorView.systemUiVisibility = (View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                    or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                    or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                    or View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                    or View.SYSTEM_UI_FLAG_FULLSCREEN
                    or View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY)
        }
    }

    // This snippet shows the system bars. It does this by removing all the flags
    // except for the ones that make the content appear under the system bars.
    fun showSystemUI(activity: Activity) {
        activity.window.decorView.systemUiVisibility = (View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN)
    }
}

object ColorUtil {
    private const val DEFAULT_COLOR = 0xffffffff.toInt()

    fun showColorChooseDialog(
            context: Context,
            initialColor: Int? = null,
            onColorSelectedListener: OnColorSelectedListener? = null,
            colorPickerClickListener: ColorPickerClickListener? = null) {
        ColorPickerDialogBuilder
                .with(context)
                .setTitle(ResourceUtil.getString(context, R.string.color_choose))
                .initialColor(initialColor ?: DEFAULT_COLOR)
                .wheelType(ColorPickerView.WHEEL_TYPE.FLOWER)
                .density(12)
                .setOnColorSelectedListener(onColorSelectedListener)
                .setPositiveButton(ResourceUtil.getString(context, R.string.confirm), colorPickerClickListener)
                .setNegativeButton(ResourceUtil.getString(context, R.string.cancel)) { _, _ -> }
                .build()
                .show()
    }
}

object ResourceUtil {

    @JvmStatic
    fun getString(context: Context, @StringRes resId: Int): String {
        return context.getString(resId)
    }

    @JvmStatic
    fun getString(context: Context, @StringRes resId: Int, vararg formatAr: Any): String {
        return context.getString(resId, *formatAr)
    }

    @JvmStatic
    fun getColor(context: Context, @ColorRes resId: Int): Int {
        return ContextCompat.getColor(context, resId)
    }

    @JvmStatic
    fun getDrawable(context: Context, @DrawableRes resId: Int): Drawable? {
        return ContextCompat.getDrawable(context, resId)
    }

    fun addAlpha(context: Context, resId: Int, alpha: Double): String {
        val alphaFixed = Math.round(alpha * 255)
        var alphaHex = alphaFixed.toString(16)
        if (alphaHex.length == 1) {
            alphaHex = "0$alphaHex"
        }
        var originalColor = getString(context, resId)
        originalColor = originalColor.replace("#ff", "#$alphaHex")

        return originalColor
    }
}