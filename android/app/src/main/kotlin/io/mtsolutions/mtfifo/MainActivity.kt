package io.mtsolutions.mtfifo

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result

import android.content.Intent
import android.content.IntentFilter
import android.content.BroadcastReceiver
import android.widget.Toast
import android.content.Context

class MainActivity: FlutterActivity() {

  private val CHANNEL = "mtfifo/scannercode";
  protected lateinit var _channel: MethodChannel;

  val receiver = object : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val message = intent.extras.getString("barcode_string")
        println("Broadcast: " + message)
        // Send scanned code to Flutter
        _channel.invokeMethod("scannercode", message)
    }
  }

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    
    val filter = IntentFilter()
    filter.addAction("android.intent.ACTION_DECODE_DATA")
    registerReceiver(receiver, filter)
    
    _channel = MethodChannel(flutterView, CHANNEL)
    _channel.setMethodCallHandler { call, result ->
     if (call.method == "getScannerCode") {
        val scannerCode = getScannerCode()
        result.success(scannerCode)
      } 
    }
  }

  private fun getScannerCode(): String {
    val scannerCode: String
    scannerCode = "CODE: "
    return scannerCode
  }
}
