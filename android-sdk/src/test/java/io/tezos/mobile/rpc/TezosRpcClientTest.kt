package io.tezos.mobile.rpc

import okhttp3.OkHttpClient
import org.junit.Assert.assertNotNull
import org.junit.Test

class TezosRpcClientTest {
    @Test
    fun buildsClient() {
        val client = TezosRpcClient("https://rpc.tzkt.io/ghostnet", OkHttpClient())
        assertNotNull(client)
    }
}


