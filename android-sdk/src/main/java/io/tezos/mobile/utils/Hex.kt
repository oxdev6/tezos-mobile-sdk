package io.tezos.mobile.utils

object Hex {
    fun encode(bytes: ByteArray): String = bytes.joinToString("") { "%02x".format(it) }
    fun decode(hex: String): ByteArray {
        val cleaned = hex.replace(" ", "").removePrefix("0x")
        require(cleaned.length % 2 == 0) { "Invalid hex length" }
        val out = ByteArray(cleaned.length / 2)
        for (i in out.indices) {
            val idx = i * 2
            out[i] = ((cleaned.substring(idx, idx + 2)).toInt(16) and 0xFF).toByte()
        }
        return out
    }
}


