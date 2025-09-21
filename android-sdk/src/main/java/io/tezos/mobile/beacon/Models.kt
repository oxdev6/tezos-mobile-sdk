package io.tezos.mobile.beacon

data class BeaconAppMetadata(
    val name: String,
    val senderId: String,
    val icon: String? = null
)

data class BeaconPairingRequest(
    val id: String,
    val type: String,
    val name: String,
    val version: String,
    val publicKey: String,
    val relayServer: String? = null,
    val icon: String? = null
)


