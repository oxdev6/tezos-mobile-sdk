import Foundation

public enum BeaconDeepLinkBuilder {
    public static func pairingURL(for walletScheme: String, request: BeaconPairingRequest) throws -> URL {
        let json = try JSONEncoder().encode(request)
        let base64 = json.base64EncodedString()
        // Scheme examples: temple://, kukai://
        var components = URLComponents()
        components.scheme = walletScheme.replacingOccurrences(of: "://", with: "")
        components.host = "beacon"
        components.path = "/pair"
        components.queryItems = [URLQueryItem(name: "data", value: base64)]
        guard let url = components.url else { throw URLError(.badURL) }
        return url
    }
}


