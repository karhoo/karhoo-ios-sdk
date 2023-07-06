//
//  KarhooTripUpdateInteractortSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

class KarhooTripUpdateInteractortSpec: XCTestCase {

    private var mockTripUpdateRequest: MockRequestSender!
    private var testObject: KarhooTripUpdateInteractor!
    let requestedTripId = "123"
    let tripId = "TRIP_ID"

    override func setUp() {
        super.setUp()
        MockSDKConfig.authenticationMethod = .tokenExchange(settings: MockSDKConfig.tokenExchangeSettings)
        mockTripUpdateRequest = MockRequestSender()
        testObject = KarhooTripUpdateInteractor(identifier: tripId,
                                                requestSender: mockTripUpdateRequest)
    }

    /**
     * When: Making a request to get trip
     * Then: Expected method, path and payload should be set
     */

    func testRequestFormat() {
        testObject.execute(callback: { (_: Result<TripInfo>) in })
        mockTripUpdateRequest.assertRequestSendAndDecoded(endpoint: .trackTrip(identifier: tripId),
                                                          method: .get)
    }

    /**
     * When: Request returns a full trip as expected
     * Then: Callback should contain said trip
     */
    func testRequestSuccess() {

        var capturedCallback: Result<TripInfo>?
        testObject.execute(callback: { capturedCallback = $0 })

        let mockResponse = TripInfoMock().set(tripId: "ABC123").build()
        mockTripUpdateRequest.triggerSuccessWithDecoded(value: mockResponse)

        XCTAssertEqual(capturedCallback!.getSuccessValue()!.tripId, "ABC123")
    }

    /**
     * When: Request fails
     * Then: Callback should contain http response error
     */
    func testRequestFailure() {
        var capturedCallback: Result<TripInfo>?
        testObject.execute(callback: { capturedCallback = $0 })

        let error = HTTPError(statusCode: 402, errorType: .badServerResponse)
        mockTripUpdateRequest.triggerFail(error: error)

        XCTAssertEqual(error, capturedCallback!.getErrorValue() as? HTTPError)
    }

    /**
     * When: Canceling a request
     * Then: Cancel network was called
     */
    func testCancelNetworkRequest() {
        testObject.cancel()
        XCTAssert(mockTripUpdateRequest.cancelNetworkRequestCalled)
    }

    /**
     * When: Tracking as a guest
     * Then: Track with follow code endpoint
     * And: Follow code is populated
     */
    func testGuestTripUpdateUsesFollowCode() {
        MockSDKConfig.authenticationMethod = .guest(settings: MockSDKConfig.guestSettings)
        testObject.execute(callback: { (result: Result<TripInfo>) in
            XCTAssertEqual("TRIP_ID", result.getSuccessValue()?.followCode)
        })

        mockTripUpdateRequest.assertRequestSendAndDecoded(endpoint: .trackTripFollowCode(followCode: tripId),
                                                          method: .get)

        let mockResponse = TripInfoMock().set(tripId: "123").build()
        mockTripUpdateRequest.triggerSuccessWithDecoded(value: mockResponse)
    }
}
