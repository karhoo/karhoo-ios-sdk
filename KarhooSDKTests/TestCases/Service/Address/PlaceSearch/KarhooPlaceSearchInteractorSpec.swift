//
//  KarhooPlaceSearchInteractorSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest

@testable import KarhooSDK

class KarhooPlaceSearchInteractorSpec: XCTestCase {

    private var mockPlaceSearchRequest: MockRequestSender!
    private var testObject: KarhooPlaceSearchInteractor!

    let testPlaceSearch: PlaceSearch = PlaceSearch(position: Position(latitude: 51,
                                                                      longitude: 20),
                                                   query: "search",
                                                   sessionToken: "19182391827")
    override func setUp() {
        super.setUp()

        mockPlaceSearchRequest = MockRequestSender()
        testObject = KarhooPlaceSearchInteractor(requestSender: mockPlaceSearchRequest)
        testObject.set(placeSearch: testPlaceSearch)
    }

    /**
      * When: Searching for a place
      * Then: The correct request should be formed
      */
    func testRequestFormat() {
        testObject.execute(callback: { (_: Result<Places>) in})
        mockPlaceSearchRequest.assertRequestSendAndDecoded(endpoint: .placeSearch,
                                                           method: .get,
                                                           payload: testPlaceSearch)
    }

    /**
     * Given: Request succeeds
     * When: Searching for a place
     * Then: The correct result should be propogated
     */
    func testRequestSuccess() {
        let expectedResponse = Places(places: [Place(placeId: "some",
                                                     displayAddress: "display")])

        var expectedResult: Result<Places>?
        testObject.execute(callback: { expectedResult = $0})

        mockPlaceSearchRequest.triggerSuccessWithDecoded(value: expectedResponse)

        XCTAssertEqual(expectedResponse.places[0].encode(), expectedResult!.getSuccessValue()!.places[0].encode()!)
        XCTAssertTrue(expectedResult!.isSuccess())
        XCTAssertNil(expectedResult!.getErrorValue())
    }

    /**
     * Given: Request succeeds
     * When: Searching for a place
     * Then: The correct result should be propogated
     */
    func testRequestFails() {
        let expectedError = TestUtil.getRandomError()

        var expectedResult: Result<Places>?

        testObject.execute(callback: { expectedResult = $0})

        mockPlaceSearchRequest.triggerFail(error: expectedError)

        XCTAssertNil(expectedResult?.getSuccessValue())
        XCTAssertFalse(expectedResult!.isSuccess())
        XCTAssert(expectedError.equals(expectedResult!.getErrorValue()!))
    }
}
