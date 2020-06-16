//
//  BookTripMethodSpec.swift
//  KarhooSDKIntegrationTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

//swiftlint:disable function_body_length

/** booking-with-nonce request tests covered in BookingInteractorSpec
    as responses between book trip and book trip with nonce are the same
**/

import XCTest
@testable import KarhooSDK

final class BookTripMethodSpec: XCTestCase {

    private var tripService: TripService!
    private let path = "/v1/bookings"
    private var call: Call<TripInfo>!

    override func setUp() {
        super.setUp()

        tripService = Karhoo.getTripService()

        let userInfo = UserInfo(userId: "",
                                firstName: "",
                                lastName: "",
                                email: "",
                                mobileNumber: "",
                                organisations: [Organisation()],
                                locale: "")

        let passengers = Passengers(additionalPassengers: 0, passengerDetails: [PassengerDetails(user: userInfo)])
        let tripBooking = TripBooking(quoteId: "123", passengers: passengers)
        call = tripService.book(tripBooking: tripBooking)
    }

    /**
     * When: Booking a trip
     * And: The result succeeds
     * Then: Expected result should be propogated
     */
    func testBookTripSuccess() {
        NetworkStub.response(fromFile: "TripInfo.json", forPath: path, statusCode: 200)

        let expectation = self.expectation(description: "calls the callback with success")

        call.execute(callback: { result in
            self.assertSuccess(result: result)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }

    /**
     * When: Booking a trip
     * And: The result fails
     * Then: Expected error should be propogated
     */
    func testBookTripFails() {
        let trackTripError = RawKarhooErrorFactory.buildError(code: "K4001")

        NetworkStub.errorResponse(path: path, responseData: trackTripError)

        let expectation = self.expectation(description: "calls callback with error result")

        call.execute(callback: { result in
            XCTAssertEqual(.couldNotBookTrip, result.errorValue()!.type)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }

    /**
     * When: Booking a trip
     * And: The response returns empty json object
     * Then: Result is success with empty TripInfo object
     */
    func testEmptyResponse() {
        NetworkStub.emptySuccessResponse(path: path)

        let expectation = self.expectation(description: "calls the callback with success")

        call.execute(callback: { result in
            XCTAssertTrue(result.isSuccess())
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
    }

    /**
     * When: Booking a trip
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

        waitForExpectations(timeout: 1)
    }

    /**
     * When: Booking a trip
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

        waitForExpectations(timeout: 1)
    }

    private func assertSuccess(result: Result<TripInfo>) {
        XCTAssert(result.isSuccess())
        guard let trip = result.successValue() else {
            XCTFail("Missing success value")
            return
        }
        XCTAssertEqual("b6a5f9dc-9066-4252-9013-be85dfa563bc", trip.tripId)
        XCTAssertEqual("1234", trip.followCode)
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
        XCTAssertEqual("dispatch-co@karhoo.com", fleetInfo.email)

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
        XCTAssertEqual(2000, tripQuote.highPrice)
        XCTAssertEqual(1000, tripQuote.lowPrice)

        let vehicleAttributes = VehicleAttributes(childSeat: true, electric: true,
                                                  hybrid: false, luggageCapacity: 2,
                                                  passengerCapacity: 3)
        XCTAssertEqual(vehicleAttributes, tripQuote.vehicleAttributes)

    }
}
