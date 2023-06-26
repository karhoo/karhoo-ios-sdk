//
//  TripSearchMethodSpec.swift
//  KarhooSDKIntegrationTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

//swiftlint:disable function_body_length

import XCTest
@testable import KarhooSDK

final class TripSearchMethodSpec: XCTestCase {

    private let path = "/v1/bookings/search"
    private var tripService: TripService!
    private var call: Call<[TripInfo]>!

    override func setUp() {
        super.setUp()

        tripService = Karhoo.getTripService()

        let tripSearch = TripSearch(tripStates: [.requested])
        call = tripService.search(tripSearch: tripSearch)

    }

    /**
      * Given: Searching for trips
      * When: Request returns successfully with expected result
      * Then: Expected result should be propogated
      */
    func testHappyPath() {
        NetworkStub.successResponse(jsonFile: "TripSearch.json", path: path)

        let expectation = self.expectation(description: "Calls callback with success response")

        call.execute(callback: { result in
            XCTAssertTrue(result.isSuccess())
            self.assertSuccess(trip: result.getSuccessValue()![0])
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
     * Given: Searching for trips
     * When: Request fails with a valid error
     * Then: Expected error should be propogated
     */
    func testErrorResponse() {
        NetworkStub.errorResponse(path: path,
                                  responseData: RawKarhooErrorFactory.buildError(code: "K4011"))

        let expectation = self.expectation(description: "Calls callback with expected error")

        call.execute(callback: { result in
            XCTAssertEqual(.couldNotGetTrip, result.getErrorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
     * Given: Searching for trips
     * When: Request fails with an invalid error
     * Then: Unknown error should be propogated
     */
    func testErrorInvalidResponse() {
        NetworkStub.responseWithInvalidData(path: path, statusCode: 400)

        let expectation = self.expectation(description: "calls callback with unknown error")

        call.execute(callback: { result in
            XCTAssertEqual(.unknownError, result.getErrorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
     * Given: Searching for trips
     * When: Request succeeds with invalid result
     * Then: Unknown error should be propogated
     */
    func testSuccessInvalidResponse() {
        NetworkStub.responseWithInvalidData(path: path, statusCode: 200)

        let expectation = self.expectation(description: "calls callback with unknown error")

        call.execute(callback: { result in
            XCTAssertEqual(.unknownError, result.getErrorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
     * Given: Searching for trips
     * When: Request succeeds with empty json
     * Then: Unknown error should be propogated
     */
    func testSuccessEmptyResponse() {
        NetworkStub.emptySuccessResponse(path: path)

        let expectation = self.expectation(description: "calls callback with empty TripInfoList")

        call.execute(callback: { result in
            XCTAssertEqual(.unknownError, result.getErrorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    /**
     * Given: Searching for trips
     * When: Request times out
     * Then: Unknown error should be propogated
     */
    func testTimeOut() {
        NetworkStub.errorResponseTimeOutConnection(path: path)

        let expectation = self.expectation(description: "calls callback with unknown error")
        call.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            XCTAssertEqual(.unknownError, result.getErrorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
    }

    private func assertSuccess(trip: TripInfo) {
        XCTAssertEqual("b6a5f9dc-9066-4252-9013-be85dfa563bc", trip.tripId)
        XCTAssertEqual(.requested, trip.state)
        XCTAssertEqual("EhpCcm93bmVsbCBTdCwgU2hlZmZpZWxkLCBVSw", trip.origin.placeId)
        XCTAssertEqual("EhpCcm93bmVsbCBTdCwgU2hlZmZpZWxkLCBVSw", trip.destination!.placeId)
        XCTAssertEqual("2018-04-21 12:35:00 +0000", trip.dateScheduled?.description)
        XCTAssertEqual(35.50, trip.tripQuote.denominateTotal)
        XCTAssertEqual("A5TH-R27D", trip.displayId)

        let fleetInfo = trip.fleetInfo
        XCTAssertEqual("some fleet id", fleetInfo.fleetId)
        XCTAssertEqual("some fleet name", fleetInfo.name)
        XCTAssertEqual("some logo url", fleetInfo.logoUrl)
        XCTAssertEqual("some description", fleetInfo.description)
        XCTAssertEqual("some phone number", fleetInfo.phoneNumber)
        XCTAssertEqual("some terms and conditions", fleetInfo.termsConditionsUrl)

        let vehicle = trip.vehicle
        XCTAssertEqual("MPV", vehicle.vehicleClass)
        XCTAssertEqual("Renault Scenic (Black)", vehicle.description)
        XCTAssertEqual("123 XYZ", vehicle.vehicleLicensePlate)

        let driver = trip.vehicle.driver
        XCTAssertEqual("Michael", driver.firstName)
        XCTAssertEqual("Higgins", driver.lastName)
        XCTAssertEqual("+441111111111", driver.phoneNumber)
        XCTAssertEqual("https://karhoo.com/drivers/mydriver.png", driver.photoUrl)
        XCTAssertEqual("ZXZ151YTY", driver.licenseNumber)

        XCTAssertEqual("BA1326", trip.flightNumber)

        let meetingPoint = trip.meetingPoint!
        XCTAssertEqual(51.5086692, meetingPoint.position.latitude)
        XCTAssertEqual(-0.1375291, meetingPoint.position.longitude)
        XCTAssertEqual(.notSet, meetingPoint.type)
        XCTAssertEqual( "string", meetingPoint.instructions)

        let tripQuote = trip.tripQuote
        XCTAssertEqual(.fixed, tripQuote.type)
        XCTAssertEqual(3550, tripQuote.total)
        XCTAssertEqual("GBP", tripQuote.currency)
        XCTAssertEqual(15, tripQuote.gratuityPercent)
        XCTAssertEqual("Saloon", tripQuote.vehicleClass)
        XCTAssertEqual(5, tripQuote.qtaLowMinutes)
        XCTAssertEqual(8, tripQuote.qtaHighMinutes)
    }
}
