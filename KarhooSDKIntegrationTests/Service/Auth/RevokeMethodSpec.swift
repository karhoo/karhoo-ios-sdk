//
//  RevokeMethodSpec.swift
//  KarhooSDKIntegrationTests
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class AuthRevokeMethodSpec: XCTestCase {
    private var authService: AuthService!
    private let revokePath = "/oauth/v2/revoke"

    private var call: Call<KarhooVoid>!

    override func setUp() {
        super.setUp()
        MockSDKConfig.authenticationMethod = .tokenExchange(settings: MockSDKConfig.tokenExchangeSettings)
        authenticate()
        authService = Karhoo.getAuthService()

        call = authService.revoke()
    }

    private func authenticate() {
        NetworkStub.successResponse(jsonFile: "AuthToken.json", path: "/oauth/v2/token-exchange")
        NetworkStub.successResponse(jsonFile: "AuthorisedUserInfo.json", path: "/oauth/v2/userinfo")

        let expectation = self.expectation(description: "calls the callback with success")

        Karhoo.getAuthService().login(token: "123").execute(callback: { _ in
            expectation.fulfill()
        })

        waitForExpectations(timeout: 2)
    }

    /**
     * When: Calling Revoke
     * Then: User should be removed
     * And: Result propogated
     */
    func testRevokeSuccess() {
        NetworkStub.emptySuccessResponse(path: revokePath)

        let expectation = self.expectation(description: "Calls callback with expected result")
        call.execute(callback: { result in
            XCTAssertTrue(result.isSuccess())
            XCTAssertNil(Karhoo.getUserService().getCurrentUser())
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1.5)
    }
}
