package com.example.englishvocabdatabase

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.widget.Button
import android.widget.TextView
import android.widget.Toast

class FloatingWindowManager(private val context: Context) {

    private var windowManager: WindowManager? = null
    private var floatingView: View? = null

    fun showFloatingWindow(text: String) {
        if (!Settings.canDrawOverlays(context)) {
            requestOverlayPermission()
            Toast.makeText(context, "請先開啟懸浮窗權限", Toast.LENGTH_LONG).show()
            return
        }

        if (floatingView != null) {
            // 如果浮動視窗已經存在，先移除再重新顯示
            removeFloatingWindow()
        }

        windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager

        val layoutParams = createLayoutParams()
        floatingView = createFloatingView(text)

        windowManager?.addView(floatingView, layoutParams)
    }

    private fun createLayoutParams(): WindowManager.LayoutParams {
        return WindowManager.LayoutParams(
            300, // 寬度，像素
            200, // 高度，像素
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            else
                WindowManager.LayoutParams.TYPE_PHONE,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.CENTER
        }
    }

    private fun createFloatingView(text: String): View {
        val inflater = context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val view = inflater.inflate(R.layout.floating_view, null)

        val textView = view.findViewById<TextView>(R.id.text_view)
        textView.text = text

        val copyButton = view.findViewById<Button>(R.id.copy_button)
        copyButton.setOnClickListener {
            copyTextToClipboard(text)
        }

        val closeButton = view.findViewById<Button>(R.id.close_button)
        closeButton.setOnClickListener {
            removeFloatingWindow()
        }

        return view
    }

    private fun copyTextToClipboard(text: String) {
        val clipboard = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        val clip = ClipData.newPlainText("label", text)
        clipboard.setPrimaryClip(clip)
        Toast.makeText(context, "文字已複製到剪貼簿", Toast.LENGTH_SHORT).show()
    }

    fun removeFloatingWindow() {
        if (floatingView != null) {
            try {
                windowManager?.removeView(floatingView)
                Toast.makeText(context, "浮動視窗已關閉", Toast.LENGTH_SHORT).show()
            } catch (e: Exception) {
                e.printStackTrace()
            }
            floatingView = null
        }
    }

    private fun requestOverlayPermission() {
        val intent = Intent(
            Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
            Uri.parse("package:${context.packageName}")
        )
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
    }
}
