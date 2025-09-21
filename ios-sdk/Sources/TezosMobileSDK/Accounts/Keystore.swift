import Foundation
import CryptoKit

@available(iOS 14.0, macOS 12.0, *)
public struct KeyPair {
    public let privateKey: Curve25519.Signing.PrivateKey
    public let publicKey: Curve25519.Signing.PublicKey
}

public enum KeystoreError: Error {
    case keyDerivationUnsupported
}

@available(iOS 14.0, macOS 12.0, *)
public final class Keystore {
    public init() {}

    public func generateKeyPair() -> KeyPair {
        let privateKey = Curve25519.Signing.PrivateKey()
        let publicKey = privateKey.publicKey
        return KeyPair(privateKey: privateKey, publicKey: publicKey)
    }
}


