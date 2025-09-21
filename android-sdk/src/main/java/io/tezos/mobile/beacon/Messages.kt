package io.tezos.mobile.beacon

enum class BeaconNetwork { mainnet, ghostnet }

data class PermissionRequest(
    val id: String,
    val type: String,
    val version: String,
    val appMetadata: BeaconAppMetadata,
    val network: BeaconNetwork?,
    val scopes: List<String>
)

data class PermissionResponse(
    val id: String,
    val type: String,
    val publicKey: String,
    val address: String
)

data class OperationDetails(
    val kind: String,
    val amount: String,
    val destination: String
)

data class OperationRequest(
    val id: String,
    val type: String,
    val sourceAddress: String,
    val network: BeaconNetwork?,
    val operationDetails: List<OperationDetails>
)

data class OperationResponse(
    val id: String,
    val type: String,
    val transactionHash: String
)

data class SignPayloadRequest(
    val id: String,
    val type: String,
    val signingType: String,
    val payload: String
)

data class SignPayloadResponse(
    val id: String,
    val type: String,
    val signature: String
)


