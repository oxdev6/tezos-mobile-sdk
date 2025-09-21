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
    case networkError(underlying: Error)
}

@available(iOS 14.0, macOS 12.0, *)
public final class TezosRPCClient {
    private let config: TezosRPCConfig

    public init(config: TezosRPCConfig) {
        self.config = config
    }

    public func getHeadHash() async throws -> String {
        let path = "/chains/main/blocks/head/hash"
        return try await getRawString(path: path)
    }

    public func getBalance(address: String) async throws -> String {
        let path = "/chains/main/blocks/head/context/contracts/\(address)/balance"
        return try await getRawString(path: path)
    }

    private func makeRequest(path: String) throws -> URLRequest {
        let url = config.baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }

    private func makePostRequest(path: String, body: Data) throws -> URLRequest {
        let url = config.baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        return request
    }

    public func getJSON<T: Decodable>(_ type: T.Type, path: String, decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        let request = try makeRequest(path: path)
        do {
            let (data, response) = try await config.urlSession.data(for: request)
            guard let http = response as? HTTPURLResponse else { throw TezosRPCError.invalidResponse }
            guard (200..<300).contains(http.statusCode) else {
                let body = String(data: data, encoding: .utf8)
                throw TezosRPCError.httpError(statusCode: http.statusCode, body: body)
            }
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw TezosRPCError.decodingError(underlying: error)
            }
        } catch {
            throw TezosRPCError.networkError(underlying: error)
        }
    }

    public func getRawString(path: String) async throws -> String {
        let request = try makeRequest(path: path)
        do {
            let (data, response) = try await config.urlSession.data(for: request)
            guard let http = response as? HTTPURLResponse else { throw TezosRPCError.invalidResponse }
            guard (200..<300).contains(http.statusCode) else {
                let body = String(data: data, encoding: .utf8)
                throw TezosRPCError.httpError(statusCode: http.statusCode, body: body)
            }
            guard let value = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                throw TezosRPCError.invalidResponse
            }
            return value.replacingOccurrences(of: "\"", with: "")
        } catch {
            throw TezosRPCError.networkError(underlying: error)
        }
    }

    // Milestone 2: inject signed operation bytes (hex string) into the network
    public func injectOperation(signedOperationHex: String) async throws -> String {
        // RPC expects a JSON string body with the hex payload
        let payload = try JSONEncoder().encode(signedOperationHex)
        let request = try makePostRequest(path: "/injection/operation?chain=main", body: payload)
        do {
            let (data, response) = try await config.urlSession.data(for: request)
            guard let http = response as? HTTPURLResponse else { throw TezosRPCError.invalidResponse }
            guard (200..<300).contains(http.statusCode) else {
                let body = String(data: data, encoding: .utf8)
                throw TezosRPCError.httpError(statusCode: http.statusCode, body: body)
            }
            guard let opHash = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                throw TezosRPCError.invalidResponse
            }
            return opHash.replacingOccurrences(of: "\"", with: "")
        } catch {
            throw TezosRPCError.networkError(underlying: error)
        }
    }
}


