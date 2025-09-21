package io.tezos.mobile.accounts

import org.bouncycastle.crypto.params.Ed25519PrivateKeyParameters
import java.security.SecureRandom

data class KeyPair(
    val privateKey: ByteArray,
    val publicKey: ByteArray
)

class Keystore(private val random: SecureRandom = SecureRandom()) {
    fun generateKeyPair(): KeyPair {
        val priv = Ed25519PrivateKeyParameters(random)
        val pub = priv.generatePublicKey()
        return KeyPair(privateKey = priv.encoded, publicKey = pub.encoded)
    }
}


