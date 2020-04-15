//
//  KarhooDriverTrackingInteractorSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

final class KarhooDriverTrackingInteractorSpec: XCTestCase {

    private var testObject: KarhooDriverTrackingInteractor!
    private let mockTripID = "Some"
    private var mockDriverTrackingRequest: MockRequestSender!

    override func setUp() {
        super.setUp()
        mockDriverTrackingRequest = MockRequestSender()
        testObject = KarhooDriverTrackingInteractor(tripId: mockTripID, requestSender: mockDriverTrackingRequest)
    }

    /**
     * When: Adding payment method
     * Then: Expected method, path and payload should be set
     */
    func testRequestFormat() {
        testObject.execute(callback: { response in
            _ = response as Result<DriverTrackingInfo>
        })

        mockDriverTrackingRequest.assertRequestSendAndDecoded(endpoint: .trackDriver(identifier: mockTripID),
                                                              method: .get,
                                                              payload: nil)
    }

    /**
     * Given: Tracking a driver (trip id)
     * When: request succeeds
     * Then: Callback should be success
     */
    func testTrackDriverSuccess() {
        var response: Result<DriverTrackingInfo>?
        testObject.execute(callback: { result in
            response = result
        })

        let driverTrackingInfo = DriverTrackingInfoMock().setOriginEta(originEta: 5).build()
        mockDriverTrackingRequest.triggerSuccessWithDecoded(value: driverTrackingInfo)

        XCTAssertEqual(5, response!.successValue()!.originEta)
    }

    /**
     * Given: Tracking a driver (trip id)
     * When: request fails
     * Then: Callback should contain expected error
     */
    func testTrackDriverFails() {
        var response: Result<DriverTrackingInfo>?
        testObject.execute(callback: { result in
            response = result
        })

        let expectedError = TestUtil.getRandomError()
        mockDriverTrackingRequest.triggerFail(error: expectedError)

        XCTAssert(expectedError.equals(response!.errorValue()))
    }
}
