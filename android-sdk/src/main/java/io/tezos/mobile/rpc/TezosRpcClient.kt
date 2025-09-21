package io.tezos.mobile.rpc

import okhttp3.Call
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.RequestBody.Companion.toRequestBody

class TezosRpcClient(
    private val baseUrl: String,
    private val httpClient: Call.Factory = OkHttpClient()
) {
    private val jsonMedia = "application/json".toMediaType()
    init {
        require(baseUrl.lowercase().startsWith("https://")) { "TezosRpcClient requires an HTTPS baseUrl" }
    }
    @Throws(Exception::class)
    fun getHeadHash(): String {
        val request = Request.Builder()
            .url("$baseUrl/chains/main/blocks/head/hash")
            .get()
            .build()
        httpClient.newCall(request).execute().use { response ->
            if (!response.isSuccessful) throw Exception("HTTP ${response.code}")
            return response.body?.string()?.trim('"', '\n', ' ', '\r') ?: throw Exception("Empty body")
        }
    }

    @Throws(Exception::class)
    fun getBalance(address: String): String {
        val request = Request.Builder()
            .url("$baseUrl/chains/main/blocks/head/context/contracts/$address/balance")
            .get()
            .build()
        httpClient.newCall(request).execute().use { response ->
            if (!response.isSuccessful) throw Exception("HTTP ${response.code}")
            return response.body?.string()?.trim('"', '\n', ' ', '\r') ?: throw Exception("Empty body")
        }
    }

    @Throws(Exception::class)
    fun getCounter(address: String): String {
        val request = Request.Builder()
            .url("$baseUrl/chains/main/blocks/head/context/contracts/$address/counter")
            .get()
            .build()
        httpClient.newCall(request).execute().use { response ->
            if (!response.isSuccessful) throw Exception("HTTP ${response.code}")
            return response.body?.string()?.trim('"', '\n', ' ', '\r') ?: throw Exception("Empty body")
        }
    }

    @Throws(Exception::class)
    fun getChainId(): String {
        val request = Request.Builder()
            .url("$baseUrl/chains/main/chain_id")
            .get()
            .build()
        httpClient.newCall(request).execute().use { response ->
            if (!response.isSuccessful) throw Exception("HTTP ${response.code}")
            return response.body?.string()?.trim('"', '\n', ' ', '\r') ?: throw Exception("Empty body")
        }
    }

    @Throws(Exception::class)
    fun postRawString(path: String, jsonBody: String): String {
        val body = jsonBody.toRequestBody(jsonMedia)
        val request = Request.Builder()
            .url("$baseUrl$path")
            .post(body)
            .build()
        httpClient.newCall(request).execute().use { response ->
            if (!response.isSuccessful) throw Exception("HTTP ${response.code}")
            return response.body?.string()?.trim('"', '\n', ' ', '\r') ?: throw Exception("Empty body")
        }
    }

    @Throws(Exception::class)
    fun injectOperation(signedOperationHex: String): String {
        val json = "\"$signedOperationHex\""
        return postRawString("/injection/operation?chain=main", json)
    }
}


