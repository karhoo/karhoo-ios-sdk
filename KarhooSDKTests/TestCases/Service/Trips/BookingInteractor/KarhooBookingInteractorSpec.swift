//
//  KarhooBookingInteractorSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
@testable import KarhooSDK

class KarhooBookingInteractorSpec: XCTestCase {

    var mockBookingRequest: MockRequestSender!
    var mockUserDataStore: MockUserDataStore!
    var mockAnalytics: MockAnalyticsService!

    var testObject: KarhooBookingInteractor!
    private let passengers = Passengers(additionalPassengers: 0,
                                        passengerDetails: [PassengerDetails(user: UserInfoMock()
                                                    .set(email: "someEmail")
                                                    .set(firstName: "someFirstName")
                                                    .set(lastName: "someLastName")
                                                    .set(mobile: "someMobile")
                                                    .build())])

    override func setUp() {
        super.setUp()

        mockBookingRequest = MockRequestSender()
        mockUserDataStore = MockUserDataStore()
        mockAnalytics = MockAnalyticsService()

        testObject = KarhooBookingInteractor(bookingRequest: mockBookingRequest)
    }

    /**
      * When: Booking a trip with no payment nonce
      * Then: The correct request and format should be sent
      */
    func testRequestFormatNoPaymentNonce() {
        let tripBooking = TripBooking(quoteId: "some",
                                      passengers: passengers,
                                      flightNumber: "312",
                                      comments: "comment")

        testObject.set(tripBooking: tripBooking)
        testObject.execute(callback: { (_:Result<TripInfo>) in })

        mockBookingRequest.assertRequestSendAndDecoded(endpoint: APIEndpoint.bookTrip,
                                                       method: .post,
                                                       payload: tripBooking)
    }

    /**
     * When: Booking a trip WITH a payment nonce
     * Then: The correct request and format should be sent
     */
    func testRequestFormatWithPaymentNonce() {
        var tripBooking = TripBooking(quoteId: "some",
                                      passengers: passengers,
                                      flightNumber: "312",
                                      comments: "comment")

        tripBooking.paymentNonce = "some_nonce"

        testObject.set(tripBooking: tripBooking)
        testObject.execute(callback: { (_:Result<TripInfo>) in })

        mockBookingRequest.assertRequestSendAndDecoded(endpoint: APIEndpoint.bookTripWithNonce,
                                                       method: .post,
                                                       payload: tripBooking)
    }

    /**
     * When: Booking a trip WITH meta data with a trip id field
     * Then: The correct request and format should be sent
     */
    func testRequestFormatWithMetadata() {
        var tripBooking = TripBooking(quoteId: "some",
                                      passengers: passengers,
                                      flightNumber: "312",
                                      comments: "comment")

        tripBooking.meta = ["trip_id": "1234"]

        testObject.set(tripBooking: tripBooking)
        testObject.execute(callback: { (_:Result<TripInfo>) in })

        mockBookingRequest.assertRequestSendAndDecoded(endpoint: APIEndpoint.bookTripWithNonce,
                                                       method: .post,
                                                       payload: tripBooking)
    }

    /**
     *   Given:  Booking a trip
     *    When:  Request succeeds
     *    Then:  Expected callback should be propogated
     */
    func testRequestSuccess() {
        let tripBooking = TripBooking(quoteId: "some",
                                      passengers: passengers,
                                      flightNumber: "312")
        var capturedCallback: Result<TripInfo>?

        testObject.set(tripBooking: tripBooking)
        testObject.execute(callback: { capturedCallback = $0 })

        mockBookingRequest.triggerSuccessWithDecoded(value: TripInfoMock().set(tripId: "some").build())

        XCTAssertEqual("some", capturedCallback!.successValue()?.tripId)
        XCTAssertTrue(capturedCallback!.isSuccess())
        XCTAssertNil(capturedCallback?.errorValue())
    }

    /**
     *   Given:  Booking a trip
     *    When:  Request fails
     *    Then:  Expected callback should be propogated
     */
    func testRequestFails() {
        let tripBooking = TripBooking(quoteId: "some",
                                      passengers: passengers,
                                      flightNumber: "312")

        var capturedCallback: Result<TripInfo>?

        testObject.set(tripBooking: tripBooking)
        testObject.execute(callback: { capturedCallback = $0 })

        let error = TestUtil.getRandomError()
        mockBookingRequest.triggerFail(error: error)
        XCTAssert(error.equals(capturedCallback!.errorValue()))
        XCTAssertFalse(capturedCallback!.isSuccess())
    }
}
