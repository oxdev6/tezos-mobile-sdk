package io.tezos.mobile.beacon

import android.net.Uri
import com.squareup.moshi.Moshi

object DeepLinkBuilder {
    private val moshi = Moshi.Builder().build()

    fun pairingUri(walletScheme: String, request: BeaconPairingRequest): Uri {
        val adapter = moshi.adapter(BeaconPairingRequest::class.java)
        val json = adapter.toJson(request)
        val base64 = android.util.Base64.encodeToString(json.toByteArray(), android.util.Base64.NO_WRAP)
        return Uri.parse("$walletScheme://beacon/pair?data=$base64")
    }
}


