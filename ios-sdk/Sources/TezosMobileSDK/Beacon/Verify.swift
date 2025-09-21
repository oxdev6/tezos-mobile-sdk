import Foundation
import CryptoKit

public enum BeaconVerify {
    // Placeholder verifier: in real flows, verify Ed25519 signature against provided public key
    public static func verifyEd25519(message: Data, signature: Data, publicKey: Curve25519.Signing.PublicKey) -> Bool {
        return publicKey.isValidSignature(signature, for: message)
    }
}

public enum BeaconRouter {
    public static func route(url: URL) -> String {
        if let _ = BeaconDeepLinkHandler.parsePairing(from: url) {
            return "pairing"
        }
        return "unknown"
    }
}
