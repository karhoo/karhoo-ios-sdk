//
//  KarhooReverseGeocodeProviderSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
import CoreLocation

@testable import KarhooSDK

class KarhooReverseGeocodeInteractorSpec: XCTestCase {

    private var mockReverseGeocodeRequest: MockRequestSender!
    private var testObject: KarhooReverseGeocodeInteractor!
    private let testPosition: Position = Position(latitude: 51.51479,
                                                  longitude: -0.1444379)

    override func setUp() {
        super.setUp()
        mockReverseGeocodeRequest = MockRequestSender()
        testObject = KarhooReverseGeocodeInteractor(requestSender: mockReverseGeocodeRequest)
        testObject.set(position: testPosition)
    }

    /**
     * When: sending request
     * Then: Expected payload, path and should be set
     */
    func testRequestFormat() {
        testObject.execute(callback: { (_: Result<Places>) in})

        mockReverseGeocodeRequest.assertRequestSendAndDecoded(endpoint: .reverseGeocode(position: testPosition),
                                                              method: .get,
                                                              payload: nil)
    }

    /**
     * When: Request succeeds
     * Then: expected callback should be propogated
     */
    func testRequestSucceeds() {
        let expectedResponse = LocationInfoMock().set(placeId: "some").set(timeZoneIdentifier: "Europe/London")

        var capturedResponse: Result<LocationInfo>?
        testObject.execute(callback: { capturedResponse = $0 })

        mockReverseGeocodeRequest.triggerSuccessWithDecoded(value: expectedResponse.build())

        XCTAssertEqual(capturedResponse!.getSuccessValue()!.placeId, expectedResponse.build().placeId)
        XCTAssertTrue(capturedResponse!.isSuccess())
        XCTAssertNil(capturedResponse?.getErrorValue())
    }

    /**
     * When: Sign up request fais
     * Then: expected callback should be propogated
     */
    func testRequestFails() {
        let expectedError = TestUtil.getRandomError()

        var capturedResponse: Result<LocationInfo>?
        testObject.execute(callback: { capturedResponse = $0 })

        mockReverseGeocodeRequest.triggerFail(error: expectedError)

        XCTAssertFalse(capturedResponse!.isSuccess())
        XCTAssert(expectedError.equals(capturedResponse!.getErrorValue()!))
    }
}
