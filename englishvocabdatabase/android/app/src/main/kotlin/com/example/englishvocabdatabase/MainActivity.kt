package com.example.englishvocabdatabase

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.englishvocabdatabase/floating_prefs"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        .setMethodCallHandler { call, result ->
            val prefs = getSharedPreferences("floating_window_prefs", MODE_PRIVATE)
            when (call.method) {
                "getAllInputs" -> {
                    val prefs = getSharedPreferences("floating_window_prefs", MODE_PRIVATE)
                    val dataList = prefs.getString("data_list", "[]")
                    result.success(dataList)  // 回傳 JSON 字串
                }
                "clearInputs" -> {
                    prefs.edit().clear().apply()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent) {
        if (Intent.ACTION_SEND == intent.action && intent.type == "text/plain") {
            val receivedText = intent.getStringExtra(Intent.EXTRA_TEXT) ?: "未收到文字"
            val serviceIntent = Intent(this, FloatingWindowService::class.java)
            serviceIntent.putExtra("text", receivedText)
            startService(serviceIntent)

            // 讓 Activity 立即結束，不會切到前景
            moveTaskToBack(true)
        }
    }
}
