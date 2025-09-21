import Foundation

@available(iOS 14.0, macOS 12.0, *)
public final class OperationService {
    private let rpc: TezosRPCClient

    public init(rpc: TezosRPCClient) {
        self.rpc = rpc
    }

    public func forgeOperations(_ request: ForgeOperationsRequest) async throws -> String {
        let data = try JSONEncoder().encode(request)
        return try await rpc.postRawString(path: "/chains/main/blocks/head/helpers/forge/operations", body: data)
    }
}


