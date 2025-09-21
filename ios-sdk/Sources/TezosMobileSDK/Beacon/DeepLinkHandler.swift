import Foundation

public enum BeaconDeepLinkHandler {
    public static func parsePairing(from url: URL) -> BeaconPairingRequest? {
        guard url.host == "beacon", url.path == "/pair" else { return nil }
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        guard let dataItem = components.queryItems?.first(where: { $0.name == "data" })?.value else { return nil }
        return try? BeaconCodec.decodePairingRequest(fromBase64: dataItem)
    }
}


