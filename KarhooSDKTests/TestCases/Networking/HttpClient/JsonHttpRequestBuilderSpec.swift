import XCTest

@testable import KarhooSDK

final class JsonHttpRequestBuilderSpec: XCTestCase {
    private var testObject: JsonHttpRequestBuilder!

    override func setUp() {
        super.setUp()

        self.testObject = JsonHttpRequestBuilder()
    }

    /**
     *    Given: Body and header provided
     *    When: Building a request
     *    Then: Result should be configured properly
     */
    func testRequestWithBody() throws {
        let request = try? self.testObject.request(method: .get,
                                                      url: URL(string: "www.google.pl")!,
                                                      headers: ["foo": "bar"],
                data: try JSONEncoder().encode(["kar": "hoo"]))

        XCTAssertNotNil(request)
        XCTAssertEqual(request!.httpMethod ?? "", "GET")
        XCTAssertEqual(request?.url?.absoluteString, "www.google.pl")
        XCTAssertEqual(request?.allHTTPHeaderFields?["foo"], "bar")

        let json = try? JSONSerialization.jsonObject(with: request?.httpBody ?? Data()) as? Json
        XCTAssertTrue(json != nil)
        XCTAssertTrue(json! == ["kar": "hoo"] as Json)
    }

    /**
     *    Given: Body and header NOT provided
     *    When: Building a request
     *    Then: Result should be configured properly
     */
    func testRequestWithoutBody() {
        let url = URL(string: "www.google.pl")!
        let request = try? self.testObject.request(method: .get, url: url, headers: nil, data: nil)

        XCTAssertNotNil(request)
        XCTAssertEqual(request!.httpMethod ?? "", "GET")
        XCTAssertEqual(request?.url?.absoluteString, "www.google.pl")
        XCTAssertNil(request?.allHTTPHeaderFields?["foo"])
        XCTAssertNil(request?.allHTTPHeaderFields?["Content-Type"])

        let json = try? JSONSerialization.jsonObject(with: request?.httpBody ?? Data())
        XCTAssertTrue(json == nil)
    }

}

private class TestNonSerializable {
}
