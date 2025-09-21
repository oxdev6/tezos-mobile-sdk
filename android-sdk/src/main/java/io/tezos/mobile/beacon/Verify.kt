package io.tezos.mobile.beacon

object BeaconVerify {
    // Placeholder: Provide Ed25519 verification using a library if needed
    fun verifyEd25519(message: ByteArray, signature: ByteArray, publicKey: ByteArray): Boolean {
        // Implementation deferred
        return true
    }
}

object BeaconRouter {
    fun route(path: String): String = when {
        path.contains("/pair") -> "pairing"
        else -> "unknown"
    }
}


