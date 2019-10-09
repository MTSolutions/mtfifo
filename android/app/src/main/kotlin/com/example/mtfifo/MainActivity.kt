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

class MainActivity: FlutterActivity() {

  private val CHANNEL = "mtfifo/scannercode";
  var receiver: BroadcastReceiver? = null;

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    

    val filter = IntentFilter()
    filter.addAction("android.intent.ACTION_DECODE_DATA")
    receiver = ScannerCodeReceiver()
    registerReceiver(receiver, filter)
    
    MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
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
