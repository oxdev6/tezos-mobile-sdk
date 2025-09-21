import Foundation

public enum BeaconNetwork: String, Codable {
    case mainnet
    case ghostnet
}

public struct PermissionRequest: Codable {
    public let id: String
    public let type: String // permission_request
    public let version: String
    public let appMetadata: BeaconAppMetadata
    public let network: BeaconNetwork?
    public let scopes: [String]
}

public struct PermissionResponse: Codable {
    public let id: String
    public let type: String // permission_response
    public let publicKey: String
    public let address: String
}

public struct OperationDetails: Codable {
    public let kind: String // transaction
    public let amount: String
    public let destination: String
}

public struct OperationRequest: Codable {
    public let id: String
    public let type: String // operation_request
    public let sourceAddress: String
    public let network: BeaconNetwork?
    public let operationDetails: [OperationDetails]
}

public struct OperationResponse: Codable {
    public let id: String
    public let type: String // operation_response
    public let transactionHash: String
}


