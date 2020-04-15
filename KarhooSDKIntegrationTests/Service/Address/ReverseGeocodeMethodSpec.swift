//
//  ReverseGeocodeMethod.swift
//  KarhooSDKIntegrationTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
import KarhooSDK

final class ReverseGeocodeMethodSpec: XCTestCase {

    private var addressService: AddressService!
    private let path = "/v1/locations/reverse-geocode"
    private var call: Call<LocationInfo>!

    override func setUp() {
        super.setUp()

        self.addressService = Karhoo.getAddressService()
        self.call = addressService.reverseGeocode(position: Position(latitude: 0, longitude: 0))
    }

    /**
     * When: Requesting location info
     * And: The response returns location info json object
     * Then: Result is success and returns LocationInfo object
     */
    func testHappyPath() {
        NetworkStub.successResponse(jsonFile: "LocationInfo.json", path: path)

        let expectation = self.expectation(description: "calls the callback with success")

        call.execute(callback: { [weak self] result in
            XCTAssertTrue(result.isSuccess())
            self?.assertLocationInfo(info: result.successValue()!)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 0.5, handler: .none)
    }

    /**
     * When: Requesting location info
     * And: The response returns an error
     * Then: Result is error
     */
    func testErrorResponse() {
        let expectedError = RawKarhooErrorFactory.buildError(code: "K2001")

        NetworkStub.errorResponse(path: path, responseData: expectedError)

        let expectation = self.expectation(description: "calls the callback with error")

        call.execute(callback: { result in
            let error = result.errorValue()
            XCTAssertEqual(.couldNotGetAddress, error?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 0.5, handler: .none)
    }

    /**
     * When: Requesting location info
     * And: The response returns empty json object
     * Then: Result is success with empty LocationInfo object
     */
    func testEmptyResponse() {
        NetworkStub.emptySuccessResponse(path: path)

        let expectation = self.expectation(description: "calls the callback with success")

        call.execute(callback: { result in
            XCTAssertTrue(result.isSuccess())
            expectation.fulfill()
        })

        waitForExpectations(timeout: 0.5, handler: .none)
    }

    /**
     * When: Requesting location info
     * And: The response returns invalid json object
     * Then: Result is error
     */
    func testInvalidResponse() {
        NetworkStub.responseWithInvalidJson(path: path, statusCode: 200)

        let expectation = self.expectation(description: "calls the callback with error")
        call.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            XCTAssertEqual(.unknownError, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 0.5, handler: .none)
    }

    /**
     * When: Requesting location info
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

        waitForExpectations(timeout: 0.5, handler: .none)
    }

    private func assertLocationInfo(info: LocationInfo) {
        XCTAssertEqual(51.5166744, info.position.latitude)
        XCTAssertEqual(-0.1769328, info.position.longitude)
        XCTAssertEqual("123", info.placeId)
        XCTAssertEqual(.regulated, info.poiType)
        let address  = LocationInfoAddress(displayAddress: "Paddington Station",
                                           lineOne: "",
                                           lineTwo: "",
                                           buildingNumber: "",
                                           streetName: "Praed St",
                                           city: "London",
                                           postalCode: "W2 1HQ",
                                           countryCode: "UK",
                                           region: "Greater London")
        XCTAssert(address.equals(info.address))
        XCTAssertEqual("UK", info.timeZoneIdentifier)
        XCTAssertEqual("iata", info.details.iata)
        XCTAssertEqual("terminal", info.details.terminal)
        XCTAssertEqual(.notSetDetailsType, info.details.type)
        XCTAssertEqual(51.5062894, info.meetingPoint.position.latitude)
        XCTAssertEqual(-0.0859324, info.meetingPoint.position.longitude)
        XCTAssertEqual("I am near by", info.meetingPoint.instructions)
        XCTAssertEqual(.curbSide, info.meetingPoint.type)
        XCTAssertEqual("Waiting", info.instructions)
    }
}
