import XCTest
@testable import TezosMobileSDK

final class TezosMobileSDKTests: XCTestCase {
    func testRPCClientBuilds() throws {
        let url = URL(string: "https://rpc.tzkt.io/ghostnet")!
        let client = TezosRPCClient(config: TezosRPCConfig(baseURL: url))
        XCTAssertNotNil(client)
    }

    func testGetHeadHashWithMock() async throws {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        MockURLProtocol.requestHandler = { request in
            let data = "\"HEAD_HASH\"".data(using: .utf8)!
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        let client = TezosRPCClient(config: TezosRPCConfig(baseURL: URL(string: "https://example.com")!, urlSession: session))
        let head = try await client.getHeadHash()
        XCTAssertEqual(head, "HEAD_HASH")
    }
}

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else { return }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() { }
}
