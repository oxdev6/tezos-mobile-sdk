import Foundation

public struct TezTransfer: Codable {
    public let source: String
    public let destination: String
    public let amount: String
    public let fee: String
    public let counter: String
    public let gasLimit: String
    public let storageLimit: String
}

public struct ForgeOperationsRequest: Codable {
    public let branch: String
    public let contents: [ForgeContent]
}

public enum ForgeContent: Codable {
    case transaction(TezTransfer)

    private enum CodingKeys: String, CodingKey { case kind }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .transaction(let t):
            var container = encoder.container(keyedBy: DynamicCodingKeys.self)
            try container.encode("transaction", forKey: DynamicCodingKeys(stringValue: "kind")!)
            try container.encode(t.source, forKey: DynamicCodingKeys(stringValue: "source")!)
            try container.encode(t.fee, forKey: DynamicCodingKeys(stringValue: "fee")!)
            try container.encode(t.counter, forKey: DynamicCodingKeys(stringValue: "counter")!)
            try container.encode(t.gasLimit, forKey: DynamicCodingKeys(stringValue: "gas_limit")!)
            try container.encode(t.storageLimit, forKey: DynamicCodingKeys(stringValue: "storage_limit")!)
            try container.encode(t.amount, forKey: DynamicCodingKeys(stringValue: "amount")!)
            try container.encode(t.destination, forKey: DynamicCodingKeys(stringValue: "destination")!)
        }
    }

    public init(from decoder: Decoder) throws {
        fatalError("Decoding not supported for this demo model")
    }
}

struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    init?(stringValue: String) { self.stringValue = stringValue }
    var intValue: Int? { return nil }
    init?(intValue: Int) { return nil }
}


