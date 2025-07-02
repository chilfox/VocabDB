package com.example.englishvocabdatabase

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    private lateinit var floatingWindowManager: FloatingWindowManager

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        floatingWindowManager = FloatingWindowManager(this)
        handleProcessTextIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleProcessTextIntent(intent)
    }

    private fun handleProcessTextIntent(intent: Intent) {
        if (Intent.ACTION_PROCESS_TEXT == intent.action) {
            val receivedText = intent.getStringExtra(Intent.EXTRA_PROCESS_TEXT)
            floatingWindowManager.showFloatingWindow(receivedText ?: "未收到文字")
        }
    }
}
