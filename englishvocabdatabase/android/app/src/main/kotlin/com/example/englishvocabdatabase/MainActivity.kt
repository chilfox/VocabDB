package com.example.englishvocabdatabase

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log
import android.content.ContentValues
import android.os.Build
import android.provider.MediaStore

class MainActivity : FlutterActivity() {

    private val FLOATING_PREFS_CHANNEL = "com.example.englishvocabdatabase/floating_prefs"
    private val MEDIA_STORE_CHANNEL = "media_store"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        Log.d("MainActivity", "configureFlutterEngine called, engine = $flutterEngine")

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, FLOATING_PREFS_CHANNEL)
        .setMethodCallHandler { call, result ->
            val prefs = getSharedPreferences("floating_window_prefs", MODE_PRIVATE)
            when (call.method) {
                "getAllInputs" -> {
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

        // 第二個 channel：media_store
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, MEDIA_STORE_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "saveCsv") {
                    val fileName = call.argument<String>("fileName") ?: "export.csv"
                    val csvContent = call.argument<String>("csvContent") ?: ""

                    val success = saveCsvToDownloads(fileName, csvContent)
                    result.success(success)
                } else {
                    result.notImplemented()
                }
            }

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d("MainActivity", "onCreate called, flutterEngine = $flutterEngine")
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        Log.d("MainActivity", "onNewIntent called, flutterEngine = $flutterEngine")
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent) {
        if (Intent.ACTION_SEND == intent.action && intent.type == "text/plain") {
            val receivedText = intent.getStringExtra(Intent.EXTRA_TEXT) ?: "未收到文字"

            Log.d("MainActivity", "handleIntent: receivedText = $receivedText")
            // 啟動權限檢查 Activity
            val permissionIntent = Intent(this, OverlayPermissionActivity::class.java)
            permissionIntent.putExtra("shared_text", receivedText)
            permissionIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(permissionIntent)

            Log.d("MainActivity", "handleIntent: end")
        }
    }


    private fun saveCsvToDownloads(fileName: String, csvContent: String): Boolean {
        return try {
            val resolver = applicationContext.contentResolver
            val contentValues = ContentValues().apply {
                put(MediaStore.Downloads.DISPLAY_NAME, fileName)
                put(MediaStore.Downloads.MIME_TYPE, "text/csv")
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    put(MediaStore.Downloads.RELATIVE_PATH, "Download/")
                }
            }

            val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, contentValues)
                ?: return false

            resolver.openOutputStream(uri).use { outputStream ->
                outputStream?.writer().use { writer ->
                    writer?.write(csvContent)
                }
            }
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

}
