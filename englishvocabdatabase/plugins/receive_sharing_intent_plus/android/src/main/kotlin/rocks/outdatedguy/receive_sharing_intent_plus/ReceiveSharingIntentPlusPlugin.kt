package rocks.outdatedguy.receive_sharing_intent_plus

import android.app.Activity
import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class ReceiveSharingIntentPlusPlugin : FlutterPlugin, ActivityAware, MethodCallHandler {
    // Channels
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel

    // Activity reference
    private var activity: Activity? = null
    private var eventSink: EventSink? = null

    companion object {
        private const val METHOD_CHANNEL = "receive_sharing_intent_plus/messages"
        private const val EVENT_CHANNEL  = "receive_sharing_intent_plus/events"
    }

    /** Flutter v2 embedding: attach to engine */
    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(binding.binaryMessenger, METHOD_CHANNEL)
        methodChannel.setMethodCallHandler(this)

        eventChannel = EventChannel(binding.binaryMessenger, EVENT_CHANNEL)
        eventChannel.setStreamHandler(object : StreamHandler {
            override fun onListen(arguments: Any?, events: EventSink?) {
                eventSink = events
            }
            override fun onCancel(arguments: Any?) {
                eventSink = null
            }
        })
    }

    /** Flutter v2 embedding: detach from engine */
    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

    override fun onDetachedFromActivityForConfigChanges() {}
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }
    override fun onDetachedFromActivity() {
        activity = null
    }

    /** Handle method calls from Dart */
    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getInitialText" -> {
                val text = activity?.intent?.getStringExtra(Intent.EXTRA_TEXT)
                result.success(text)
            }
            else -> result.notImplemented()
        }
    }

    /** Common intent handler: send shared text events */
    private fun handleIntent(intent: Intent) {
        if (intent.action == Intent.ACTION_SEND && intent.type == "text/plain") {
            val sharedText = intent.getStringExtra(Intent.EXTRA_TEXT)
            // Send to stream listeners
            eventSink?.success(sharedText)
        }
    }
    
    /** 分享時快速變回後台 */
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addOnNewIntentListener { intent ->
            handleIntent(intent)
            if (intent.action == Intent.ACTION_SEND && intent.type == "text/plain") {
                activity?.moveTaskToBack(true)
            }
            false
        }
        activity?.intent?.let { intent ->
            handleIntent(intent)
            if (intent.action == Intent.ACTION_SEND && intent.type == "text/plain") {
                activity?.moveTaskToBack(true)
            }
        }
    }
}