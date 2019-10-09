package io.mtsolutions.mtfifo
 
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.widget.Toast
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

// const MethodChannel channel = const MethodChannel(CHANNEL)

class ScannerCodeReceiver : BroadcastReceiver() {

    
    override fun onReceive(context: Context, intent: Intent) {
        // TODO: This method is called when the BroadcastReceiver is receiving
        // an Intent broadcast.
        val message = "Broadcast detected " + intent.extras.getString("barcode_string")
        println("Broadcast: " + intent.extras.getString("barcode_string"))
        Toast.makeText(context, message, Toast.LENGTH_LONG).show()
    }
}