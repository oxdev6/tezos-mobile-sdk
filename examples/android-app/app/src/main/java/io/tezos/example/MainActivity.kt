package io.tezos.example

import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import io.tezos.mobile.beacon.BeaconPairingRequest
import io.tezos.mobile.beacon.DeepLinkBuilder
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
                val pairing = BeaconPairingRequest(
                    id = java.util.UUID.randomUUID().toString(),
                    type = "p2p-pairing-request",
                    name = "AndroidExample",
                    version = "3",
                    publicKey = "PUBLIC_KEY_PLACEHOLDER",
                    relayServer = null,
                    icon = null
                )
                val uri = DeepLinkBuilder.pairingUri("temple", pairing)
                runOnUiThread { tv.text = "Head: $head\nPair: $uri" }
            } catch (e: Exception) {
                runOnUiThread { tv.text = "Error: ${e.message}" }
            }
        }.start()
    }
}


