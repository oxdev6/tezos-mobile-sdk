package io.tezos.example

import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import io.tezos.mobile.rpc.TezosRpcClient

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val tv = TextView(this)
        tv.text = "Loading..."
        setContentView(tv)

        Thread {
            try {
                val client = TezosRpcClient("https://rpc.tzkt.io/ghostnet")
                val head = client.getHeadHash()
                runOnUiThread { tv.text = "Head: $head" }
            } catch (e: Exception) {
                runOnUiThread { tv.text = "Error: ${e.message}" }
            }
        }.start()
    }
}


