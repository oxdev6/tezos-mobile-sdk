package io.tezos.mobile.operations

import com.squareup.moshi.Moshi
import com.squareup.moshi.Types
import io.tezos.mobile.rpc.TezosRpcClient
import io.tezos.mobile.utils.Hex
import org.bouncycastle.crypto.params.Ed25519PrivateKeyParameters
import org.bouncycastle.crypto.signers.Ed25519Signer

class OperationService(private val rpc: TezosRpcClient) {
    private val moshi = Moshi.Builder().build()

    fun forgeOperations(request: ForgeOperationsRequest): String {
        val mapType = Types.newParameterizedType(Map::class.java, String::class.java, Any::class.java)
        val listType = Types.newParameterizedType(List::class.java, mapType)
        val adapter = moshi.adapter<Map<String, Any>>(mapType)
        val rootAdapter = moshi.adapter<Map<String, Any>>(mapType)

        val contentsJson = moshi.adapter<List<Map<String, Any>>>(listType).toJson(request.contents)
        val json = "{" +
                "\"branch\":\"${request.branch}\"," +
                "\"contents\":$contentsJson" +
                "}"
        return rpc.postRawString("/chains/main/blocks/head/helpers/forge/operations", json)
    }

    fun signForgedAppendSignature(forgedHex: String, privateKey: Ed25519PrivateKeyParameters): String {
        val forged = Hex.decode(forgedHex)
        val signer = Ed25519Signer()
        signer.init(true, privateKey)
        // watermark 0x03 + forged
        val watermarked = byteArrayOf(0x03) + forged
        signer.update(watermarked, 0, watermarked.size)
        val sig = signer.generateSignature()
        return Hex.encode(forged + sig)
    }

    fun sendTez(branch: String, transfer: TezTransfer, privateKey: Ed25519PrivateKeyParameters): String {
        val content = OperationBuilder.transactionContent(transfer)
        val forgedHex = forgeOperations(ForgeOperationsRequest(branch, listOf(content)))
        val signedHex = signForgedAppendSignature(forgedHex, privateKey)
        return rpc.injectOperation(signedHex)
    }

    fun autoSendTez(
        source: String,
        destination: String,
        amountMutez: String,
        feeMutez: String = "10000",
        gasLimit: String = "10300",
        storageLimit: String = "300",
        privateKey: Ed25519PrivateKeyParameters
    ): String {
        val branch = rpc.getHeadHash()
        val counterStr = rpc.getCounter(source)
        val nextCounter = (counterStr.toLongOrNull() ?: 0L) + 1
        val transfer = TezTransfer(
            source = source,
            destination = destination,
            amount = amountMutez,
            fee = feeMutez,
            counter = nextCounter.toString(),
            gasLimit = gasLimit,
            storageLimit = storageLimit
        )
        return sendTez(branch, transfer, privateKey)
    }

    // FA1.2 token transfer: parameters = { entrypoint: "transfer", value: Pair(from, Pair(to, amount)) }
    private fun buildFA12Parameters(from: String, to: String, amount: String): Map<String, Any> = mapOf(
        "entrypoint" to "transfer",
        "value" to mapOf(
            "prim" to "Pair",
            "args" to listOf(
                mapOf("string" to from),
                mapOf(
                    "prim" to "Pair",
                    "args" to listOf(
                        mapOf("string" to to),
                        mapOf("int" to amount)
                    )
                )
            )
        )
    )

    private fun forgeTransactionRaw(
        branch: String,
        source: String,
        destination: String,
        fee: String,
        counter: String,
        gasLimit: String,
        storageLimit: String,
        amount: String,
        parameters: Map<String, Any>?
    ): String {
        val content = mutableMapOf<String, Any>(
            "kind" to "transaction",
            "source" to source,
            "fee" to fee,
            "counter" to counter,
            "gas_limit" to gasLimit,
            "storage_limit" to storageLimit,
            "amount" to amount,
            "destination" to destination
        )
        if (parameters != null) content["parameters"] = parameters
        val root = mapOf(
            "branch" to branch,
            "contents" to listOf(content)
        )
        val json = moshi.adapter(Map::class.java).toJson(root)
        return rpc.postRawString("/chains/main/blocks/head/helpers/forge/operations", json)
    }

    fun sendFA12Transfer(
        source: String,
        contract: String,
        from: String,
        to: String,
        amount: String,
        feeMutez: String = "15000",
        gasLimit: String = "20000",
        storageLimit: String = "300",
        privateKey: Ed25519PrivateKeyParameters
    ): String {
        val branch = rpc.getHeadHash()
        val counterStr = rpc.getCounter(source)
        val nextCounter = (counterStr.toLongOrNull() ?: 0L) + 1
        val params = buildFA12Parameters(from, to, amount)
        val forgedHex = forgeTransactionRaw(
            branch,
            source,
            contract,
            feeMutez,
            nextCounter.toString(),
            gasLimit,
            storageLimit,
            "0",
            params
        )
        val signedHex = signForgedAppendSignature(forgedHex, privateKey)
        return rpc.injectOperation(signedHex)
    }

    // FA2 transfer helper
    private fun buildFA2Parameters(from: String, to: String, tokenId: String, amount: String): Map<String, Any> = mapOf(
        "entrypoint" to "transfer",
        "value" to listOf(
            mapOf(
                "prim" to "Pair",
                "args" to listOf(
                    mapOf("string" to from),
                    mapOf(
                        "list" to listOf(
                            mapOf(
                                "prim" to "Pair",
                                "args" to listOf(
                                    mapOf("string" to to),
                                    mapOf(
                                        "prim" to "Pair",
                                        "args" to listOf(
                                            mapOf("int" to tokenId),
                                            mapOf("int" to amount)
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )
    )

    fun sendFA2Transfer(
        source: String,
        contract: String,
        from: String,
        to: String,
        tokenId: String,
        amount: String,
        feeMutez: String = "18000",
        gasLimit: String = "25000",
        storageLimit: String = "350",
        privateKey: Ed25519PrivateKeyParameters
    ): String {
        val branch = rpc.getHeadHash()
        val counterStr = rpc.getCounter(source)
        val nextCounter = (counterStr.toLongOrNull() ?: 0L) + 1
        val params = buildFA2Parameters(from, to, tokenId, amount)
        val forgedHex = forgeTransactionRaw(
            branch,
            source,
            contract,
            feeMutez,
            nextCounter.toString(),
            gasLimit,
            storageLimit,
            "0",
            params
        )
        val signedHex = signForgedAppendSignature(forgedHex, privateKey)
        return rpc.injectOperation(signedHex)
    }

    fun getFA2Balance(
        contract: String,
        viewName: String = "balance_of",
        owner: String,
        tokenId: String
    ): String {
        val root = mapOf(
            "view" to viewName,
            "input" to mapOf(
                "prim" to "Pair",
                "args" to listOf(
                    mapOf(
                        "list" to listOf(
                            mapOf(
                                "prim" to "Pair",
                                "args" to listOf(
                                    mapOf("string" to owner),
                                    mapOf("int" to tokenId)
                                )
                            )
                        )
                    ),
                    mapOf("unit" to null)
                )
            ),
            "chain_id" to rpc.getChainId()
        )
        val json = moshi.adapter(Map::class.java).toJson(root)
        return rpc.postRawString("/chains/main/blocks/head/context/contracts/$contract/single_run_view", json)
    }
}


