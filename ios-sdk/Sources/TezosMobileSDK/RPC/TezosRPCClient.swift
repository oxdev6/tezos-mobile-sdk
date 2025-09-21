import Foundation

public struct TezosRPCConfig {
    public let baseURL: URL
    public let urlSession: URLSession

    public init(baseURL: URL, urlSession: URLSession = .shared) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }
}

public enum TezosRPCError: Error {
    case invalidResponse
    case httpError(statusCode: Int, body: String?)
    case decodingError(underlying: Error)
}

public final class TezosRPCClient {
    private let config: TezosRPCConfig

    public init(config: TezosRPCConfig) {
        self.config = config
    }

    public func getHeadHash() async throws -> String {
        let path = "/chains/main/blocks/head/hash"
        let request = try makeRequest(path: path)
        let (data, response) = try await config.urlSession.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw TezosRPCError.invalidResponse }
        guard (200..<300).contains(http.statusCode) else {
            let body = String(data: data, encoding: .utf8)
            throw TezosRPCError.httpError(statusCode: http.statusCode, body: body)
        }
        guard let hash = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            throw TezosRPCError.invalidResponse
        }
        return hash.replacingOccurrences(of: "\"", with: "")
    }

    public func getBalance(address: String) async throws -> String {
        let path = "/chains/main/blocks/head/context/contracts/\(address)/balance"
        let request = try makeRequest(path: path)
        let (data, response) = try await config.urlSession.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw TezosRPCError.invalidResponse }
        guard (200..<300).contains(http.statusCode) else {
            let body = String(data: data, encoding: .utf8)
            throw TezosRPCError.httpError(statusCode: http.statusCode, body: body)
        }
        guard let balance = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            throw TezosRPCError.invalidResponse
        }
        return balance.replacingOccurrences(of: "\"", with: "")
    }

    private func makeRequest(path: String) throws -> URLRequest {
        let url = config.baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}


