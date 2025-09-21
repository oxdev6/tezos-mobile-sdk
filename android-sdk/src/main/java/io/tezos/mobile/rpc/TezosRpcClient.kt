package io.tezos.mobile.rpc

import okhttp3.OkHttpClient
import okhttp3.Request

class TezosRpcClient(
    private val baseUrl: String,
    private val httpClient: OkHttpClient = OkHttpClient()
) {
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
}


