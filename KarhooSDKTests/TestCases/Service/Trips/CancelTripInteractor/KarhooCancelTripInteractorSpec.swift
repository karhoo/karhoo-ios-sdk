//
//  KarhooCancelTripInteractorSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

final class KarhooCancelTripInteractorSpec: XCTestCase {

    private var testObject: KarhooCancelTripInteractor!
    private var mockCancelTripRequestSender: MockRequestSender!
    private var mockAnalyticsService: MockAnalyticsService!

    private let tripCancellationMock = TripCancellation(tripId: "some_tripId",
                                                        cancelReason: .notNeededAnymore)
    override func setUp() {
        super.setUp()
        mockCancelTripRequestSender = MockRequestSender()
        mockAnalyticsService = MockAnalyticsService()

        testObject = KarhooCancelTripInteractor(requestSender: mockCancelTripRequestSender,
                                                analyticsService: mockAnalyticsService)
        testObject.set(tripCancellation: tripCancellationMock)
    }

    /**
      * When: Making request
      * Then: Correct payload, method, path and request should be sent
      */
    func testRequestFormat() {
        testObject.execute(callback: { (_:Result<KarhooVoid>) in  })

        let endpoint = APIEndpoint.cancelTrip(identifier: tripCancellationMock.tripId)

        let testPayload = CancelTripRequestPayload(reason: tripCancellationMock.cancelReason)

        mockCancelTripRequestSender.assertRequestSend(endpoint: endpoint,
                                                      method: .post,
                                                      payload: testPayload)
    }

    /**
      * When: Cancel trip request is successful
      * Then: Callback should be successful
      * And: Analytics should call tripCancellationAttempt
      */
    func testRequestSucceeds() {
        var capturedCallback: Result<KarhooVoid>?
        testObject.execute(callback: { capturedCallback = $0 })

        mockCancelTripRequestSender.triggerSuccess(response: KarhooVoid().encode()!)

        XCTAssertTrue(mockAnalyticsService.tripCancellationAttemptedCalled)
        XCTAssertTrue(capturedCallback!.isSuccess())
    }

    /**
      * When: Cancel trip request fails
      * Then: Callback should fail
      * And: Analytics should call tripCancellationAttempt
      */
    func testRequestFails() {
        let expectedError = TestUtil.getRandomError()

        var capturedCallback: Result<KarhooVoid>?
        testObject.execute(callback: { capturedCallback = $0 })

        mockCancelTripRequestSender.triggerFail(error: expectedError)

        XCTAssertTrue(mockAnalyticsService.tripCancellationAttemptedCalled)
        XCTAssertFalse(capturedCallback!.isSuccess())
        XCTAssert(expectedError.equals(capturedCallback!.errorValue()))
    }
}
