import XCTest
@testable import TezosMobileSDK

final class TezosMobileSDKTests: XCTestCase {
    func testRPCClientBuilds() throws {
        let url = URL(string: "https://rpc.tzkt.io/ghostnet")!
        let client = TezosRPCClient(config: TezosRPCConfig(baseURL: url))
        XCTAssertNotNil(client)
    }
}
