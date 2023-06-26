//
//  KarhooTripsListInteractorSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

final class KarhooTripsListInteractorSpec: XCTestCase {

    private var mockTripSearchRequest: MockRequestSender!
    private var testObject: KarhooTripSearchInteractor!

    override func setUp() {
        super.setUp()
        mockTripSearchRequest = MockRequestSender()
        testObject = KarhooTripSearchInteractor(requestSender: mockTripSearchRequest)
    }

    /**
     * When: Making a request
     * Then: Expected method, path and payload should be set
     */
    func testRequestFormat() {
        let tripStates: [TripState] = [.requested,
                                       .confirmed,
                                       .driverEnRoute,
                                       .arrived,
                                       .passengerOnBoard]

        let testPayload = TripSearch(tripStates: tripStates)
        testObject.set(tripSearch: testPayload)
        testObject.execute(callback: {(_: Result<[TripInfo]>) in })

        mockTripSearchRequest.assertRequestSendAndDecoded(endpoint: APIEndpoint.tripSearch,
                                                          method: .post,
                                                          payload: testPayload)
    }

    /**
     * When: The request succeeds
     * Then: Callback should contain expected result
     */
    func testRequestSuccess() {
        var capturedCallback: Result<[TripInfo]>?

        testObject.set(tripSearch: TripSearch())
        testObject.execute(callback: { capturedCallback = $0 })

       let mockResponse = BookingSearch(trips: [TripInfoMock().set(tripId: "123").build(),
                                                TripInfoMock().set(tripId: "456").build()])
        mockTripSearchRequest.triggerSuccessWithDecoded(value: mockResponse)

        XCTAssertEqual("123", capturedCallback?.getSuccessValue()![0].tripId)
        XCTAssertEqual("456", capturedCallback?.getSuccessValue()![1].tripId)
    }

    /**
     * When: Request fails
     * Then: Error should be in callback
     */
    func testRequestFails() {
        let error = TestUtil.getRandomError()
        var capturedCallback: Result<[TripInfo]>?

        testObject.set(tripSearch: TripSearch())
        testObject.execute(callback: { capturedCallback = $0 })

        mockTripSearchRequest.triggerFail(error: error)

        XCTAssertNotNil(capturedCallback?.getErrorValue())
        XCTAssert(error.equals(capturedCallback!.getErrorValue()))
    }
}
