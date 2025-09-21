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

    public static func encodePermissionRequest(_ req: PermissionRequest) throws -> String {
        let data = try JSONEncoder().encode(req)
        return data.base64EncodedString()
    }

    public static func decodePermissionRequest(_ base64: String) throws -> PermissionRequest {
        guard let data = Data(base64Encoded: base64) else { throw URLError(.cannotDecodeContentData) }
        return try JSONDecoder().decode(PermissionRequest.self, from: data)
    }

    public static func encodeOperationRequest(_ req: OperationRequest) throws -> String {
        let data = try JSONEncoder().encode(req)
        return data.base64EncodedString()
    }

    public static func decodeOperationRequest(_ base64: String) throws -> OperationRequest {
        guard let data = Data(base64Encoded: base64) else { throw URLError(.cannotDecodeContentData) }
        return try JSONDecoder().decode(OperationRequest.self, from: data)
    }

    public static func encodeSignPayloadRequest(_ req: SignPayloadRequest) throws -> String {
        let data = try JSONEncoder().encode(req)
        return data.base64EncodedString()
    }

    public static func decodeSignPayloadRequest(_ base64: String) throws -> SignPayloadRequest {
        guard let data = Data(base64Encoded: base64) else { throw URLError(.cannotDecodeContentData) }
        return try JSONDecoder().decode(SignPayloadRequest.self, from: data)
    }
}


