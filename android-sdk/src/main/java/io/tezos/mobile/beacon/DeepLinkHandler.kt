package io.tezos.mobile.beacon

import android.net.Uri

object DeepLinkHandler {
    fun parsePairing(uri: Uri): BeaconPairingRequest? {
        if (uri.host != "beacon" || uri.path != "/pair") return null
        val data = uri.getQueryParameter("data") ?: return null
        return Codec.decodePairingRequest(data)
    }
}


