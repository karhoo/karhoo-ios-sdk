//
//  UIConfigMethodSpec.swift
//  KarhooSDKIntegrationTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

final class UIConfigMethod: XCTestCase {

    private var configService: ConfigService!
    private var call: Call<UIConfig>!

    override func setUp() {
        super.setUp()

        authenticate()
        self.configService = Karhoo.getConfigService()
    }

    private func authenticate() {
        NetworkStub.successResponse(jsonFile: "AuthToken.json", path: "/oauth/v2/token-exchange")
        NetworkStub.successResponse(jsonFile: "AuthorisedUserInfo.json", path: "/oauth/v2/userinfo")

        let expectation = self.expectation(description: "calls the callback with success")

        Karhoo.getAuthService().login(token: "123").execute(callback: { _ in
            expectation.fulfill()
           })
        
        waitForExpectations(timeout: 10)
    }

    /**
     * When: Getting UIConfig for a configurable view
     * Then: Expected config should return
     */
    func testHappyPath() {
        let payload = UIConfigRequest(viewId: "additionalFeedbackButton")
        self.call = configService.uiConfig(uiConfigRequest: payload)

        let expectation = self.expectation(description: "calls the callback with success")

        call.execute(callback: { result in
            XCTAssertTrue(result.isSuccess())
            XCTAssertFalse(result.getSuccessValue()?.hidden ?? false)

            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
     * When: Getting UIConfig for a view that is not configured
     * Then: Expected error should return
     */
    func testNoConfig() {
        let payload = UIConfigRequest(viewId: "some")
        self.call = configService.uiConfig(uiConfigRequest: payload)

        let expectation = self.expectation(description: "calls the callback with success")

        call.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            XCTAssertEqual("KSDK05", result.getErrorValue()?.code)

            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }
}
