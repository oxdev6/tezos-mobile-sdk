import Foundation
import CryptoKit

@available(iOS 14.0, macOS 12.0, *)
public enum OperationSigner {
    public static func signOperationAndAppendSignature(forgedHex: String, privateKey: Curve25519.Signing.PrivateKey) throws -> String {
        guard let forged = Data(hexString: forgedHex) else { throw TezosRPCError.invalidResponse }
        var watermarked = Data([0x03])
        watermarked.append(forged)
        let signature = try privateKey.signature(for: watermarked)
        var signedBytes = forged
        signedBytes.append(signature)
        return signedBytes.hexString()
    }
}


