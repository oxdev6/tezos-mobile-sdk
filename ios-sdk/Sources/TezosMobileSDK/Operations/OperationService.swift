import Foundation
import CryptoKit

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

    public func sendTez(
        branch: String,
        transfer: TezTransfer,
        privateKey: Curve25519.Signing.PrivateKey
    ) async throws -> String {
        let forgeReq = ForgeOperationsRequest(branch: branch, contents: [.transaction(transfer)])
        let forgedHex = try await forgeOperations(forgeReq)
        let signedHex = try OperationSigner.signOperationAndAppendSignature(forgedHex: forgedHex, privateKey: privateKey)
        return try await rpc.injectOperation(signedOperationHex: signedHex)
    }

    public func autoSendTez(
        from source: String,
        to destination: String,
        amountMutez: String,
        feeMutez: String = "10000",
        gasLimit: String = "10300",
        storageLimit: String = "300",
        privateKey: Curve25519.Signing.PrivateKey
    ) async throws -> String {
        let branch = try await rpc.getHeadHash()
        let counterStr = try await rpc.getCounter(address: source)
        let nextCounter = (UInt64(counterStr) ?? 0) + 1
        let transfer = TezTransfer(
            source: source,
            destination: destination,
            amount: amountMutez,
            fee: feeMutez,
            counter: String(nextCounter),
            gasLimit: gasLimit,
            storageLimit: storageLimit
        )
        return try await sendTez(branch: branch, transfer: transfer, privateKey: privateKey)
    }
}


