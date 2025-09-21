import Foundation
import TezosMobileSDK

@main
struct Main {
    static func main() async {
        guard let url = URL(string: "https://rpc.tzkt.io/ghostnet") else { return }
        let rpc = TezosRPCClient(config: TezosRPCConfig(baseURL: url))
        do {
            let head = try await rpc.getHeadHash()
            print("Head: \(head)")

            let pairing = BeaconPairingRequest(
                id: UUID().uuidString,
                type: "p2p-pairing-request",
                name: "TezosMobileExample",
                version: "3",
                publicKey: "PUBLIC_KEY_PLACEHOLDER",
                relayServer: nil,
                icon: nil
            )
            if let deeplink = try? BeaconDeepLinkBuilder.pairingURL(for: "temple://", request: pairing) {
                print("Pairing URL: \(deeplink)")
            }

            let signReq = SignPayloadRequest(id: UUID().uuidString, type: "sign_payload_request", signingType: "raw", payload: "0xdeadbeef")
            let encoded = try BeaconCodec.encodeSignPayloadRequest(signReq)
            let decoded = try BeaconCodec.decodeSignPayloadRequest(encoded)
            print("SignPayload decoded type: \(decoded.type)")
        } catch {
            print("Error: \(error)")
        }
    }
}


