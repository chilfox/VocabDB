package com.skfoxwh.englishvocabdatabase

import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.os.Build
import android.provider.Settings
import android.view.*
import android.widget.*
import org.json.JSONArray
import org.json.JSONObject
import android.net.Uri
import android.view.inputmethod.InputMethodManager
import android.util.Log

class FloatingWindowService : Service() {

    private var windowManager: WindowManager? = null
    private var floatingView: View? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val sharedText = intent?.getStringExtra("text") ?: "未收到文字"
        Log.d("FloatingWindowService", "Service 啟動收到文字: $sharedText")

        if (!Settings.canDrawOverlays(this)) {
            val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION)
            intent.data = Uri.parse("package:$packageName")
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            startActivity(intent)

            Toast.makeText(this, "請先允許懸浮窗權限", Toast.LENGTH_LONG).show()
            stopSelf()
            return START_NOT_STICKY
        }

        showFloatingWindow(sharedText)
        return START_NOT_STICKY
    }

    private fun showFloatingWindow(sharedText: String) {
        removeFloatingWindowIfNeeded()
        initWindowManager()
        initFloatingView()
        setupViews(sharedText)
        addFloatingViewToWindow()
    }

    private fun removeFloatingWindowIfNeeded() {
        if (floatingView != null) {
            windowManager?.removeView(floatingView)
            floatingView = null
        }
    }

    private fun initWindowManager() {
        if (windowManager == null) {
            windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
        }
    }

    private fun initFloatingView() {
        val inflater = getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val contextThemeWrapper = ContextThemeWrapper(this, R.style.AppTheme)  // 你自己定義的 MaterialComponents 主題
        val themedInflater = inflater.cloneInContext(contextThemeWrapper)
        floatingView = themedInflater.inflate(R.layout.floating_view, null)
    }


    private fun setupViews(sharedText: String) {
        val mainLayout = floatingView!!.findViewById<LinearLayout>(R.id.main_layout)
        val textShare = floatingView!!.findViewById<TextView>(R.id.text_share)
        val inputDefinition = floatingView!!.findViewById<EditText>(R.id.definition)
        val inputChinese = floatingView!!.findViewById<EditText>(R.id.chinese)
        val saveButton = floatingView!!.findViewById<Button>(R.id.save_button)
        val closeButton = floatingView!!.findViewById<Button>(R.id.close_button)

        val errorLayout = floatingView!!.findViewById<LinearLayout>(R.id.error_layout)
        val errorCloseButton = floatingView!!.findViewById<Button>(R.id.error_close_button)

        // 解析文字
        val regex = Regex("[A-Za-z](?:[A-Za-z-]*[A-Za-z])?")
        val match = regex.find(sharedText)

        // 確保EditText可聚焦
        inputDefinition.isFocusable = true
        inputDefinition.isFocusableInTouchMode = true
        inputChinese.isFocusable = true
        inputChinese.isFocusableInTouchMode = true

        // 強制在點擊時叫出鍵盤
        val imm = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        inputDefinition.setOnTouchListener { v, event ->
            if (event.action == MotionEvent.ACTION_UP) {
                Log.d("FloatingWindowService", "inputDefinition 被點擊，準備延遲呼叫鍵盤")
                v.postDelayed({
                    Log.d("FloatingWindowService", "開始呼叫鍵盤")
                    v.requestFocus()
                    val imm = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
                    imm.showSoftInput(inputDefinition, InputMethodManager.SHOW_IMPLICIT)
                }, 100)  // 延遲100毫秒
            }
            false
        }

        if (match != null && match.value != "https") {
            // 顯示正常輸入區
            mainLayout.visibility = View.VISIBLE
            errorLayout.visibility = View.GONE

            // 設定顯示的文字為解析出的 match
            textShare.text = match.value

            // 載入之前存的資料
            val prefs = getSharedPreferences("floating_window_prefs", Context.MODE_PRIVATE)
            inputDefinition.setText(prefs.getString("definition", ""))
            inputChinese.setText(prefs.getString("chinese", ""))

            saveButton.setOnClickListener {
                val edit1 = inputDefinition.text.toString()
                val edit2 = inputChinese.text.toString()
                appendEntryToPrefs(match.value, edit1, edit2)
                Toast.makeText(this, "已儲存", Toast.LENGTH_SHORT).show()
                removeFloatingWindowIfNeeded()
                stopSelf()
            }

            closeButton.setOnClickListener {
                removeFloatingWindowIfNeeded()
                stopSelf()
            }
        } else {
            // 顯示錯誤訊息區
            mainLayout.visibility = View.GONE
            errorLayout.visibility = View.VISIBLE

            errorCloseButton.setOnClickListener {
                removeFloatingWindowIfNeeded()
                stopSelf()
            }
        }
    }

    private fun addFloatingViewToWindow() {
        val type = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        } 
        else {
            WindowManager.LayoutParams.TYPE_PHONE
        }

        val flags = WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN or
            WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
            WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH

        val layoutParams = WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            type,
            flags,
            PixelFormat.TRANSLUCENT
        )

        layoutParams.gravity = Gravity.CENTER
        layoutParams.softInputMode = WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN or
                             WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE

        windowManager?.addView(floatingView, layoutParams)
    }

    private fun appendEntryToPrefs(sharedText: String, definition: String, chinese: String) {
        val prefs = getSharedPreferences("floating_window_prefs", Context.MODE_PRIVATE)
        val jsonArrayString = prefs.getString("data_list", "[]")
        val jsonArray = JSONArray(jsonArrayString)

        val newEntry = JSONObject().apply {
            put("shared_text", sharedText)
            put("definition", definition)
            put("chinese", chinese)
        }
        jsonArray.put(newEntry)

        prefs.edit().putString("data_list", jsonArray.toString()).apply()

        Log.d("FloatingWindowService", "存入資料後 data_list: $jsonArray")
    }

    override fun onBind(intent: Intent?) = null
}
