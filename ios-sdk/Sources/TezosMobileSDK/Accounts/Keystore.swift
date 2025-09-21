import Foundation
import CryptoKit

public struct KeyPair {
    public let privateKey: Curve25519.Signing.PrivateKey
    public let publicKey: Curve25519.Signing.PublicKey
}

public enum KeystoreError: Error {
    case keyDerivationUnsupported
}

public final class Keystore {
    public init() {}

    public func generateKeyPair() -> KeyPair {
        let privateKey = Curve25519.Signing.PrivateKey()
        let publicKey = privateKey.publicKey
        return KeyPair(privateKey: privateKey, publicKey: publicKey)
    }
}


