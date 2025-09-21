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
}


