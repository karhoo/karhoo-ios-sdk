//
//  KarhooLocationInfoInteractorSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest

@testable import KarhooSDK

class KarhooLocationInfoInteractorSpec: XCTestCase {

    private var mockLocationInfoRequestSender: MockRequestSender!
    private var testObject: KarhooLocationInfoInteractor!

    override func setUp() {
        super.setUp()
        mockLocationInfoRequestSender = MockRequestSender()
        testObject = KarhooLocationInfoInteractor(requestSender: mockLocationInfoRequestSender)
        testObject.set(locationInfoSearch: LocationInfoSearch(placeId: "123", sessionToken: "12354"))
    }

    /**
      * When: A request is made for location details
      * Then: The correct request should be sent
      */
    func testRequestFormat() {
        let request = LocationInfoSearch(placeId: "some_placeId",
                                         sessionToken: "some_token")
        testObject.set(locationInfoSearch: request)
        
        testObject.execute(callback: { (_: Result<LocationInfo>) in})

        mockLocationInfoRequestSender.assertRequestSendAndDecoded(endpoint: .locationInfo,
                                                                  method: .get,
                                                                  payload: request)
    }

    /**
     * When: Making a successful request
     * Then: Expected result should be propogated
     */
    func testRequestSuccess() {
        let expectedResponse = LocationInfoMock().set(placeId: "some").set(timeZoneIdentifier: "some").build()

        var capturedResponse: Result<LocationInfo>?
        testObject.execute(callback: { capturedResponse = $0 })

        mockLocationInfoRequestSender.triggerSuccessWithDecoded(value: expectedResponse)

        XCTAssertTrue(capturedResponse!.isSuccess())
        XCTAssertNil(capturedResponse?.getErrorValue())
        XCTAssertEqual(expectedResponse.encode(), capturedResponse!.getSuccessValue()!.encode())
    }

    /**
     * When: Request fails
     *  Then: Error should be propogated
     */
    func testRequestFails() {
        let expectedError = TestUtil.getRandomError()

        var capturedResponse: Result<LocationInfo>?
        testObject.execute(callback: { capturedResponse = $0 })

        mockLocationInfoRequestSender.triggerFail(error: expectedError)

        XCTAssertFalse(capturedResponse!.isSuccess())
        XCTAssertNil(capturedResponse?.getSuccessValue())
        XCTAssert(expectedError.equals(capturedResponse!.getErrorValue()!))
    }
}
