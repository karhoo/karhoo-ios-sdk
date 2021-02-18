//
//  TrackTripMethodSpec.swift
//  KarhooSDKIntegrationTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

//swiftlint:disable function_body_length

import XCTest
@testable import KarhooSDK

final class TrackTripMethodSpec: XCTestCase {

    private var tripService: TripService!
    private let path = "/v1/bookings/123"
    private var pollCall: PollCall<TripInfo>!

    override func setUp() {
        super.setUp()

        tripService = Karhoo.getTripService()

        pollCall = tripService.trackTrip(identifier: "123")
    }

    /**
     * When: Getting a trip
     * And: The result succeeds
     * Then: Expected result should be propogated
     */
    func testExecuteTrackTripSuccess() {
        NetworkStub.response(fromFile: "TripInfo.json", forPath: path, statusCode: 200)

        let expectation = self.expectation(description: "calls the callback with success")

        pollCall.execute(callback: { result in
            self.assertSuccess(result: result)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }

    /**
     * When: Getting a trip
     * And: The result fails
     * Then: Expected error should be propogated
     */
    func testExecuteTrackTripFails() {
        let trackTripError = RawKarhooErrorFactory.buildError(code: "K4011")

        NetworkStub.errorResponse(path: path, responseData: trackTripError)

        let expectation = self.expectation(description: "calls callback with error result")

        pollCall.execute(callback: { result in
            XCTAssertEqual(.couldNotGetTrip, result.errorValue()!.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }

    /**
     * Given: Getting a trip
     * When: The request succeeds
     * And: Then the request fails
     * Then: Two results should be propogated as expected
     */
    func testTrackTripPolling() {
        NetworkStub.response(fromFile: "TripInfo.json", forPath: path, statusCode: 200)

        var trackTripResults: [Result<TripInfo>] = []
        let expectation = self.expectation(description: "polling returns 2 times")

        let observer = Observer { (result: Result<TripInfo>) in
            trackTripResults.append(result)
            NetworkStub.errorResponse(path: self.path,
                                      responseData: RawKarhooErrorFactory.buildError(code: "K4012"))

            if trackTripResults.count == 2 {
                self.assertSuccess(result: trackTripResults[0])
                XCTAssertEqual(.couldNotGetTripCouldNotFindSpecifiedTrip, trackTripResults[1].errorValue()?.type)
                expectation.fulfill()
            }
        }
        pollCall.observable(pollTime: 0.3).subscribe(observer: observer)
        waitForExpectations(timeout: 1)
    }

    /**
     * Given: Getting a trip
     * When: The request times out
     * Then: Result is unknown error
     */
    func testTimeOut() {
        NetworkStub.errorResponseTimeOutConnection(path: path)

        let expectation = self.expectation(description: "calls the callback with error")
        pollCall.execute(callback: { result in
            XCTAssertFalse(result.isSuccess())
            XCTAssertEqual(.unknownError, result.errorValue()?.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }

    private func assertSuccess(result: Result<TripInfo>) {
        XCTAssert(result.isSuccess())
        guard let trip = result.successValue() else {
            XCTFail("Missing success value")
            return
        }
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
        XCTAssertEqual(.meetAndGreet, meetingPoint.type)
        XCTAssertEqual( "string", meetingPoint.instructions)

        let tripQuote = trip.tripQuote
        XCTAssertEqual(.fixed, tripQuote.type)
        XCTAssertEqual(3550, tripQuote.total)
        XCTAssertEqual("GBP", tripQuote.currency)
        XCTAssertEqual(15, tripQuote.gratuityPercent)
        XCTAssertEqual("Saloon", tripQuote.vehicleClass)
        XCTAssertEqual(5, tripQuote.qtaLowMinutes)
        XCTAssertEqual(8, tripQuote.qtaHighMinutes)
        
        let serviceAgreementsCancellation = trip.serviceAgreements?.serviceCancellation
        XCTAssertEqual("string", serviceAgreementsCancellation?.type)
        XCTAssertEqual(5, serviceAgreementsCancellation?.minutes)
        
        let serviceAgreementsWaiting = trip.serviceAgreements?.serviceWaiting
        XCTAssertEqual(5, serviceAgreementsWaiting?.minutes)
    }
}
