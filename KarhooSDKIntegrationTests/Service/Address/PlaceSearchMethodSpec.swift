//
//  PlaceSearchMethodSpec.swift
//  KarhooSDKIntegrationTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class PlaceSearchMethodSpec: XCTestCase {

    private var addressService: AddressService!
    private let path = "/v1/locations/address-autocomplete"
    private var call: Call<Places>!

    override func setUp() {
        super.setUp()

        addressService = Karhoo.getAddressService()
        call = addressService.placeSearch(placeSearch: PlaceSearch(position: Position(latitude: 1, longitude: 1),
                                                                   query: "123",
                                                                   sessionToken: "1234"))
    }

    /**
      * Given: Searching for a place
      * When: The response returns expected result
      * Then: Result should be success with expected result
      */
    func testHappyPath() {
        NetworkStub.successResponse(jsonFile: "Places.json", path: path)

        let expectation = self.expectation(description: "Calls calback with success result")

        call.execute(callback: { result in
            self.assertSuccess(result: result)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1.5)
    }

    /**
     * Given: Searching for a place
     * When: The response returns error
     * Then: Result should be a fail with expected error type
     */
    func testErrorResponse() {
        NetworkStub.errorResponse(path: path, responseData: RawKarhooErrorFactory.buildError(code: "K2002"))

        let expectation = self.expectation(description: "Calls calback with error result")

        call.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            XCTAssertEqual(.couldNotAutocompleteAddress, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1.5)
    }

    /**
     * Given: Searching for a place
     * And: The response returns empty json object
     * Then: Result is an unknownError
     */
    func testEmptyResponse() {
        NetworkStub.emptySuccessResponse(path: path)

        let expectation = self.expectation(description: "calls the callback with error")

        call.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            XCTAssertEqual(.unknownError, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 0.75, handler: .none)
    }

    /**
     * Given: Searching for a place
     * And: The response returns invalid json object
     * Then: Result is an unknownError
     */
    func testInvalidResponse() {
        NetworkStub.responseWithInvalidJson(path: path, statusCode: 200)

        let expectation = self.expectation(description: "calls the callback with error")
        call.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            XCTAssertEqual(.unknownError, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 0.75, handler: .none)
    }

    /**
     * When: Searching for a place
     * And: The response returns time out error
     * Then: Result is error
     */
    func testTimeOut() {
        NetworkStub.errorResponseTimeOutConnection(path: path)

        let expectation = self.expectation(description: "calls the callback with error")
        call.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            XCTAssertEqual(.unknownError, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 0.75, handler: .none)
    }

    private func assertSuccess(result: Result<Places>) {
        XCTAssertTrue(result.isSuccess())

        let firstPlace = result.successValue()!.places[0]
        let secondPlace = result.successValue()!.places[1]

        XCTAssertEqual("ChIJ3QD47p1xdkgRytPI0DjT6SU", firstPlace.placeId)
        XCTAssertEqual("Terminal 5, Longford, Hounslow, UK", firstPlace.displayAddress)
        XCTAssertEqual(PoiDetailsType.airport, firstPlace.poiDetailsType)

        XCTAssertEqual("12356344f35gergedr", secondPlace.placeId)
        XCTAssertEqual("Johns house", secondPlace.displayAddress)
        XCTAssertEqual(PoiDetailsType.notSetDetailsType, secondPlace.poiDetailsType)
    }
}
