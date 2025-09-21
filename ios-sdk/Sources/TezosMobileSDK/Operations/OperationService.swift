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

    // MARK: - FA1.2 Token Transfer

    private func buildFA12Parameters(from: String, to: String, amount: String) -> [String: Any] {
        // { entrypoint: "transfer", value: Pair(from, Pair(to, amount)) }
        return [
            "entrypoint": "transfer",
            "value": [
                "prim": "Pair",
                "args": [
                    ["string": from],
                    [
                        "prim": "Pair",
                        "args": [
                            ["string": to],
                            ["int": amount]
                        ]
                    ]
                ]
            ]
        ]
    }

    private func forgeTransactionRaw(
        branch: String,
        source: String,
        destination: String,
        fee: String,
        counter: String,
        gasLimit: String,
        storageLimit: String,
        amount: String,
        parameters: [String: Any]?
    ) async throws -> String {
        var content: [String: Any] = [
            "kind": "transaction",
            "source": source,
            "fee": fee,
            "counter": counter,
            "gas_limit": gasLimit,
            "storage_limit": storageLimit,
            "amount": amount,
            "destination": destination
        ]
        if let parameters = parameters {
            content["parameters"] = parameters
        }
        let body: [String: Any] = [
            "branch": branch,
            "contents": [content]
        ]
        let data = try JSONSerialization.data(withJSONObject: body, options: [])
        return try await rpc.postRawString(path: "/chains/main/blocks/head/helpers/forge/operations", body: data)
    }

    public func sendFA12Transfer(
        source: String,
        contract: String,
        from: String,
        to: String,
        amount: String,
        feeMutez: String = "15000",
        gasLimit: String = "20000",
        storageLimit: String = "300",
        privateKey: Curve25519.Signing.PrivateKey
    ) async throws -> String {
        let branch = try await rpc.getHeadHash()
        let counterStr = try await rpc.getCounter(address: source)
        let nextCounter = (UInt64(counterStr) ?? 0) + 1
        let params = buildFA12Parameters(from: from, to: to, amount: amount)
        // Contract call carries 0 tez; the token amount is in parameters
        let forgedHex = try await forgeTransactionRaw(
            branch: branch,
            source: source,
            destination: contract,
            fee: feeMutez,
            counter: String(nextCounter),
            gasLimit: gasLimit,
            storageLimit: storageLimit,
            amount: "0",
            parameters: params
        )
        let signedHex = try OperationSigner.signOperationAndAppendSignature(forgedHex: forgedHex, privateKey: privateKey)
        return try await rpc.injectOperation(signedOperationHex: signedHex)
    }

    // MARK: - FA2 Token Transfer

    private func buildFA2Parameters(from: String, to: String, tokenId: String, amount: String) -> [String: Any] {
        // transfer: [ { from_: from, txs: [ { to_: to, token_id: tokenId, amount } ] } ]
        return [
            "entrypoint": "transfer",
            "value": [
                [
                    "prim": "Pair",
                    "args": [
                        ["string": from],
                        [
                            "list": [
                                [
                                    "prim": "Pair",
                                    "args": [
                                        ["string": to],
                                        [
                                            "prim": "Pair",
                                            "args": [
                                                ["int": tokenId],
                                                ["int": amount]
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    }

    public func sendFA2Transfer(
        source: String,
        contract: String,
        from: String,
        to: String,
        tokenId: String,
        amount: String,
        feeMutez: String = "18000",
        gasLimit: String = "25000",
        storageLimit: String = "350",
        privateKey: Curve25519.Signing.PrivateKey
    ) async throws -> String {
        let branch = try await rpc.getHeadHash()
        let counterStr = try await rpc.getCounter(address: source)
        let nextCounter = (UInt64(counterStr) ?? 0) + 1
        let params = buildFA2Parameters(from: from, to: to, tokenId: tokenId, amount: amount)
        let forgedHex = try await forgeTransactionRaw(
            branch: branch,
            source: source,
            destination: contract,
            fee: feeMutez,
            counter: String(nextCounter),
            gasLimit: gasLimit,
            storageLimit: storageLimit,
            amount: "0",
            parameters: params
        )
        let signedHex = try OperationSigner.signOperationAndAppendSignature(forgedHex: forgedHex, privateKey: privateKey)
        return try await rpc.injectOperation(signedOperationHex: signedHex)
    }

    // MARK: - FA2 Balance using run_view
    public func getFA2Balance(
        contract: String,
        viewName: String = "balance_of",
        owner: String,
        tokenId: String
    ) async throws -> String {
        // POST /chains/main/blocks/head/context/contracts/<KT1>/single_run_view
        let path = "/chains/main/blocks/head/context/contracts/\(contract)/single_run_view"
        let input: [String: Any] = [
            "view": viewName,
            "input": [
                "prim": "Pair",
                "args": [
                    [
                        "list": [
                            [
                                "prim": "Pair",
                                "args": [
                                    ["string": owner],
                                    ["int": tokenId]
                                ]
                            ]
                        ]
                    ],
                    ["prim": "Unit"]
                ]
            ],
            "chain_id": try await rpc.getChainId()
        ]
        let data = try JSONSerialization.data(withJSONObject: input, options: [])
        let result = try await rpc.postRawString(path: path, body: data)
        return result
    }

    // Batch helpers
    public struct FA2Tx {
        public let to: String
        public let tokenId: String
        public let amount: String
        public init(to: String, tokenId: String, amount: String) {
            self.to = to; self.tokenId = tokenId; self.amount = amount
        }
    }

    public func buildFA2BatchParameters(from source: String, txs: [FA2Tx]) -> [String: Any] {
        let txList: [[String: Any]] = txs.map { tx in
            [
                "prim": "Pair",
                "args": [
                    ["string": tx.to],
                    [
                        "prim": "Pair",
                        "args": [
                            ["int": tx.tokenId],
                            ["int": tx.amount]
                        ]
                    ]
                ]
            ]
        }
        return [
            "entrypoint": "transfer",
            "value": [
                [
                    "prim": "Pair",
                    "args": [
                        ["string": source],
                        ["list": txList]
                    ]
                ]
            ]
        ]
    }

    public func getFA2Balances(
        contract: String,
        pairs: [(owner: String, tokenId: String)],
        viewName: String = "balance_of"
    ) async throws -> String {
        let list: [[String: Any]] = pairs.map { pair in
            [
                "prim": "Pair",
                "args": [
                    ["string": pair.owner],
                    ["int": pair.tokenId]
                ]
            ]
        }
        let body: [String: Any] = [
            "view": viewName,
            "input": [
                "prim": "Pair",
                "args": [
                    ["list": list],
                    ["prim": "Unit"]
                ]
            ],
            "chain_id": try await rpc.getChainId()
        ]
        let data = try JSONSerialization.data(withJSONObject: body, options: [])
        return try await rpc.postRawString(path: "/chains/main/blocks/head/context/contracts/\(contract)/single_run_view", body: data)
    }
}


