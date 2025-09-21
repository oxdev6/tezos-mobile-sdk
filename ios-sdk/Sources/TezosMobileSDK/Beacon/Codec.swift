import Foundation

public enum BeaconCodec {
    public static func encodePairingRequest(_ request: BeaconPairingRequest) throws -> String {
        let data = try JSONEncoder().encode(request)
        return data.base64EncodedString()
    }

    public static func decodePairingRequest(fromBase64 base64: String) throws -> BeaconPairingRequest {
        guard let data = Data(base64Encoded: base64) else { throw URLError(.cannotDecodeContentData) }
        return try JSONDecoder().decode(BeaconPairingRequest.self, from: data)
    }
}


