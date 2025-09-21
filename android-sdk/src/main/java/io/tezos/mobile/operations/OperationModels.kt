package io.tezos.mobile.operations

data class TezTransfer(
    val source: String,
    val destination: String,
    val amount: String,
    val fee: String,
    val counter: String,
    val gasLimit: String,
    val storageLimit: String
)

data class ForgeOperationsRequest(
    val branch: String,
    val contents: List<Map<String, Any>>
)

object OperationBuilder {
    fun transactionContent(t: TezTransfer): Map<String, Any> = mapOf(
        "kind" to "transaction",
        "source" to t.source,
        "fee" to t.fee,
        "counter" to t.counter,
        "gas_limit" to t.gasLimit,
        "storage_limit" to t.storageLimit,
        "amount" to t.amount,
        "destination" to t.destination
    )
}


