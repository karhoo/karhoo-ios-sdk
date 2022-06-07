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
        NetworkStub.successResponse(jsonFile: "AuthToken.json", path: "/v1/auth/token")
        NetworkStub.successResponse(jsonFile: "AuthorisedUserInfo.json", path: "/v1/directory/users/me")

        let expectation = self.expectation(description: "calls the callback with success")

        Karhoo.getUserService().login(userLogin: UserLogin(username: "mock",
                                                           password: "mock")).execute(callback: { _ in
                                                            expectation.fulfill()
                                                           })
        waitForExpectations(timeout: 1)
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
            XCTAssertFalse(result.successValue()?.hidden ?? false)

            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
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
            XCTAssertEqual("KSDK05", result.errorValue()?.code)

            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }
}
