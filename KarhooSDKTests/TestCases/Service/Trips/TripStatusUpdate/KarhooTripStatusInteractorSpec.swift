//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

final class KarhooTripStatusInteractorSpec: XCTestCase {

    private var mockTripStatusRequest: MockRequestSender!
    private var testObject: KarhooTripStatusInteractor!

    let tripId = "TRIP_ID"

    override func setUp() {
        super.setUp()

        mockTripStatusRequest = MockRequestSender()
        testObject = KarhooTripStatusInteractor(tripId: tripId,
                                                requestSender: mockTripStatusRequest)
    }

    /**
     * When: Making a request to get trip
     * Then: Expected method, path and payload should be set
     */

    func testRequestFormat() {
        testObject.execute(callback: { (_: Result<TripState>) in })
        mockTripStatusRequest.assertRequestSendAndDecoded(endpoint: .tripStatus(identifier: tripId),
                                                          method: .get)
        XCTAssertNil(mockTripStatusRequest.payloadSet?.encode())
    }

    /**
      * Given: Requesting status for a trip
      * When: The request succeeds
      * Then: Callback should be a success with a trip state result
      */
    func testRequestSuccess() {
        let successResult = TripStatusMock().set(state: .confirmed).build()

        var capturedCallback: Result<TripState>?
        testObject.execute(callback: { capturedCallback = $0 })

        mockTripStatusRequest.triggerSuccessWithDecoded(value: successResult)

        XCTAssertEqual(.confirmed, capturedCallback!.successValue()!)
    }

    /**
      * Given: Requesting status for a trip
      * When: The request fails
      * Then: Callback should be a fail with expected error
      */
    func testRequestFailure() {
        let expectedError = TestUtil.getRandomError()

        var capturedCallback: Result<TripState>?
        testObject.execute(callback: { capturedCallback = $0 })

        mockTripStatusRequest.triggerFail(error: expectedError)

        XCTAssert(expectedError.equals(capturedCallback!.errorValue()))
    }

    /**
      * When: Cancelling the request for trip status
      * Then: TripStatusRequest should cancel
      */
    func testCancelRequest() {
        testObject.cancel()
        XCTAssertTrue(mockTripStatusRequest.cancelNetworkRequestCalled)
    }
}
