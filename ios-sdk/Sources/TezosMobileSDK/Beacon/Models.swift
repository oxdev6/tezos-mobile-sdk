import Foundation

public enum BeaconMessageType: String, Codable {
    case permissionRequest
    case operationRequest
    case signPayloadRequest
    case broadcastRequest
}

public struct BeaconAppMetadata: Codable {
    public let name: String
    public let senderId: String
    public let icon: String?

    public init(name: String, senderId: String, icon: String? = nil) {
        self.name = name
        self.senderId = senderId
        self.icon = icon
    }
}

public struct BeaconPairingRequest: Codable {
    public let id: String
    public let type: String // e.g., "p2p-pairing-request"
    public let name: String
    public let version: String // e.g., "3"
    public let publicKey: String
    public let relayServer: String?
    public let icon: String?

    public init(
        id: String,
        type: String,
        name: String,
        version: String,
        publicKey: String,
        relayServer: String? = nil,
        icon: String? = nil
    ) {
        self.id = id
        self.type = type
        self.name = name
        self.version = version
        self.publicKey = publicKey
        self.relayServer = relayServer
        self.icon = icon
    }
}


