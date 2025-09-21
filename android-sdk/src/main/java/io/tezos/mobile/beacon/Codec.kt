package io.tezos.mobile.beacon

import android.util.Base64
import com.squareup.moshi.Moshi

object Codec {
    private val moshi = Moshi.Builder().build()
    private val pairingAdapter = moshi.adapter(BeaconPairingRequest::class.java)
    private val permReqAdapter = moshi.adapter(PermissionRequest::class.java)
    private val opReqAdapter = moshi.adapter(OperationRequest::class.java)

    fun encodePairingRequest(req: BeaconPairingRequest): String {
        val json = pairingAdapter.toJson(req)
        return Base64.encodeToString(json.toByteArray(), Base64.NO_WRAP)
    }

    fun decodePairingRequest(base64: String): BeaconPairingRequest? {
        return try {
            val json = String(Base64.decode(base64, Base64.NO_WRAP))
            pairingAdapter.fromJson(json)
        } catch (e: Exception) { null }
    }

    fun encodePermissionRequest(req: PermissionRequest): String {
        val json = permReqAdapter.toJson(req)
        return Base64.encodeToString(json.toByteArray(), Base64.NO_WRAP)
    }

    fun decodePermissionRequest(base64: String): PermissionRequest? {
        return try {
            val json = String(Base64.decode(base64, Base64.NO_WRAP))
            permReqAdapter.fromJson(json)
        } catch (e: Exception) { null }
    }

    fun encodeOperationRequest(req: OperationRequest): String {
        val json = opReqAdapter.toJson(req)
        return Base64.encodeToString(json.toByteArray(), Base64.NO_WRAP)
    }

    fun decodeOperationRequest(base64: String): OperationRequest? {
        return try {
            val json = String(Base64.decode(base64, Base64.NO_WRAP))
            opReqAdapter.fromJson(json)
        } catch (e: Exception) { null }
    }
}


