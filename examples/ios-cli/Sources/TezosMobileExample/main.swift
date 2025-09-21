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
        } catch {
            print("Error: \(error)")
        }
    }
}


