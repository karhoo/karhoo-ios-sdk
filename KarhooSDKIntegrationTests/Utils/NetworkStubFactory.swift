//
//  NetworkStub.swift
//  KarhooSDKIntegrationTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import OHHTTPStubsSwift
import OHHTTPStubs

final class NetworkStub {

    static func emptySuccessResponse(path: String) {
        stub(condition: isPath(path)) { _ in
            let stubPath = OHPathForFile("Empty.json", NetworkStub.self)
            return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type": "application/json"])
        }
    }

    static func successResponse(jsonFile: String, path: String) {
        stub(condition: isPath(path)) { _ in
            let stubPath = OHPathForFile(jsonFile, NetworkStub.self)
            return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type": "application/json"])
        }
    }

    static func errorResponse(path: String, responseData: Data) {
        stub(condition: isPath(path)) { _ in
            return HTTPStubsResponse(data: responseData,
                                       statusCode: 400,
                                       headers: ["Content-Type": "application/json"])
        }
    }

    static func responseWithInvalidData(path: String, statusCode: Int32) {
        stub(condition: isPath(path)) { _ in
            let stubPath = OHPathForFile("InvalidData.json", NetworkStub.self)
            return fixture(filePath: stubPath!, status: statusCode, headers: ["Content-Type": "application/json"])
        }
    }

    static func responseWithInvalidJson(path: String, statusCode: Int32) {
        stub(condition: isPath(path)) { _ in
            let stubPath = OHPathForFile("InvalidJson.json", NetworkStub.self)
            return fixture(filePath: stubPath!, status: statusCode, headers: ["Content-Type": "application/json"])
        }
    }

    static func errorResponseNoNetworkConnection(path: String) {
        stub(condition: isPath(path)) { _ in
            let notConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue)
            return HTTPStubsResponse(error: notConnectedError)
        }
    }

    static func errorResponseTimeOutConnection(path: String) {
        stub(condition: isPath(path)) { _ in
            let timeOutError = NSError(domain: NSURLErrorDomain, code: URLError.timedOut.rawValue)
            return HTTPStubsResponse(error: timeOutError)
        }
    }

    static func response(fromFile fileName: String,
                         forPath path: String,
                         statusCode: Int32) {
        stub(condition: isPath(path)) { _ in
            let stubPath = OHPathForFile(fileName, NetworkStub.self)
            return fixture(filePath: stubPath!, status: statusCode, headers: ["Content-Type": "application/json"])
        }
    }

    static func clearStubs() {
        HTTPStubs.removeAllStubs()
    }
}
