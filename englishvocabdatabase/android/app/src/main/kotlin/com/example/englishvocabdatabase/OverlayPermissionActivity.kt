package com.example.englishvocabdatabase

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.provider.Settings
import androidx.appcompat.app.AppCompatActivity
import android.util.Log
import android.widget.Toast

class OverlayPermissionActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d("OverlayPermissionActivity", "onCreate called")
        //確認啟動
        Toast.makeText(this, "OverlayPermissionActivity started", Toast.LENGTH_SHORT).show()
        checkPermissionAndStart()
    }

    private fun checkPermissionAndStart() {
        val canDraw = Settings.canDrawOverlays(this)
        Log.d("OverlayPermissionActivity", "canDrawOverlays = $canDraw")

        if (canDraw) {
            startFloatingWindowService()
            // 讓 Activity 立即結束，不會切到前景
            moveTaskToBack(true)
            finish()
        } else {
            val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION)
            intent.data = Uri.parse("package:$packageName")
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        }
    }

    override fun onResume() {
        super.onResume()
        Log.d("OverlayPermissionActivity", "onResume called")
        if (Settings.canDrawOverlays(this)) {
            startFloatingWindowService()
            moveTaskToBack(true)
            finish()
        }
    }

    private fun startFloatingWindowService() {
        val sharedText = intent.getStringExtra("shared_text") ?: ""
        Log.d("OverlayPermissionActivity", "Starting FloatingWindowService with text: $sharedText")
        val serviceIntent = Intent(this, FloatingWindowService::class.java)
        serviceIntent.putExtra("text", sharedText)
        startService(serviceIntent)
    }
}
