package io.tezos.mobile.beacon

import android.util.Base64
import com.squareup.moshi.Moshi

object Codec {
    private val moshi = Moshi.Builder().build()
    private val adapter = moshi.adapter(BeaconPairingRequest::class.java)

    fun encodePairingRequest(req: BeaconPairingRequest): String {
        val json = adapter.toJson(req)
        return Base64.encodeToString(json.toByteArray(), Base64.NO_WRAP)
    }

    fun decodePairingRequest(base64: String): BeaconPairingRequest? {
        return try {
            val json = String(Base64.decode(base64, Base64.NO_WRAP))
            adapter.fromJson(json)
        } catch (e: Exception) { null }
    }
}


