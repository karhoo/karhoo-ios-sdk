//
//  KarhooAuthRevokeInteractorSpec.swift
//  KarhooSDKTests
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import XCTest
@testable import KarhooSDK

final class KarhoooAuthRevokeInteractorSpec: XCTestCase {

    private var testObject: KarhoooAuthRevokeInteractor!
    private var mockRevokeRequest: MockRequestSender!
    private var mockUserDataStore: MockUserDataStore!
    private var mockAnalytics: MockAnalyticsService!
    
    override func setUp() {
        super.setUp()
        mockAnalytics = MockAnalyticsService()
        mockRevokeRequest = MockRequestSender()
        mockUserDataStore = MockUserDataStore()

        testObject = KarhoooAuthRevokeInteractor(userDataStore: mockUserDataStore,
                                                 revokeRequestSender: mockRevokeRequest,
                                                 analytics: mockAnalytics)
    }

    /**
      * When: Cancelling revoke
      * Then: Revoke request should be cancelled
      */
    func testCancel() {
        testObject.cancel()
        XCTAssertTrue(mockRevokeRequest.cancelNetworkRequestCalled)
    }
    
    /**
     * Given: Revoke succeeds
     * Then: Callback should be success
     */
    func testRevokeSuccess() {
        var result: Result<KarhooVoid>?
        let user = UserInfoMock().set(userId: "some").build()
        mockUserDataStore.userToReturn = user
    
        testObject.execute(callback: { result = $0 })
        mockRevokeRequest.triggerEncodedRequestSuccess(value: KarhooVoid())

        XCTAssertTrue(mockUserDataStore.removeUserCalled)
        XCTAssertEqual(mockAnalytics.eventSent, .ssoTokenRevoked)
        XCTAssertNotNil(result!.successValue())
    }
}
