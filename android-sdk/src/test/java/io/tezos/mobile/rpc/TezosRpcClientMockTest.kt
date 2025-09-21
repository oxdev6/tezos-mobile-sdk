package io.tezos.mobile.rpc

import okhttp3.Call
import okhttp3.Protocol
import okhttp3.Request
import okhttp3.Response
import okhttp3.ResponseBody
import org.junit.Assert.assertEquals
import org.junit.Test

class TezosRpcClientMockTest {
    private class FakeCallFactory(private val responder: (Request) -> Response) : Call.Factory {
        override fun newCall(request: Request): Call {
            return object : Call {
                override fun request(): Request = request
                override fun execute(): Response = responder(request)
                override fun enqueue(responseCallback: Call.Callback) { throw UnsupportedOperationException() }
                override fun cancel() {}
                override fun isExecuted(): Boolean = false
                override fun isCanceled(): Boolean = false
                override fun timeout() = okhttp3.Timeout()
                override fun clone(): Call = this
            }
        }
    }

    @Test
    fun getHeadHash_usesMockResponse() {
        val factory = FakeCallFactory { req ->
            Response.Builder()
                .request(req)
                .protocol(Protocol.HTTP_1_1)
                .code(200)
                .message("OK")
                .body(ResponseBody.create(null, "\"HEAD_HASH\""))
                .build()
        }
        val client = TezosRpcClient("https://example.com", factory)
        val head = client.getHeadHash()
        assertEquals("HEAD_HASH", head)
    }
}


