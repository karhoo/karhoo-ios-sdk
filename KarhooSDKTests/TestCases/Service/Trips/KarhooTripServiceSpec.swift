//
//  KarhooTripServiceSpec.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class KarhooTripServiceSpec: XCTestCase {

    private var testObject: KarhooTripService!
    private var mockTripBookingInteractor: MockBookingInteractor!
    private var mockCancelTripInteractor: MockCancelTripInteractor!
    private var mockTripSearchInteractor: MockTripSearchInteractor!
    private var mockCancellationFeeInteractor: MockCancellationFeeInteractor!

    private var mocktripPollFactory: MockPollCallFactory!
    private var mocktripStatusPollFactory: MockPollCallFactory!
    private var mockAnalytics: MockAnalyticsService!
    private let mockPassengers = Passengers(additionalPassengers: 0,
                                            passengerDetails: [PassengerDetails(user: UserInfoMock().build())])

    private let tripCancellationMock = TripCancellation(tripId: "some_tripId",
                                                        cancelReason: .notNeededAnymore)
    override func setUp() {
        super.setUp()

        mockTripBookingInteractor = MockBookingInteractor()
        mockCancelTripInteractor = MockCancelTripInteractor()
        mockTripSearchInteractor = MockTripSearchInteractor()
        mocktripPollFactory = MockPollCallFactory()
        mocktripStatusPollFactory = MockPollCallFactory()
        mockAnalytics = MockAnalyticsService()
        mockCancellationFeeInteractor = MockCancellationFeeInteractor()

        testObject = KarhooTripService(bookingInteractor: mockTripBookingInteractor,
                                       cancelTripInteractor: mockCancelTripInteractor,
                                       tripSearchInteractor: mockTripSearchInteractor,
                                       analytics: mockAnalytics,
                                       tripPollFactory: mocktripPollFactory,
                                       tripStatusPollFactory: mocktripStatusPollFactory,
                                       cancellationFeeInteractor: mockCancellationFeeInteractor)
    }

    /**
     *  Given: Request succeeded
     *  When:  Booking a trip
     *  Then:  TripBooker captured parameters are correct
     *   And:  Correct trip is returned in callback
     */
    func testBookingTripRequestSuccess() {
        let tripBooking = TripBooking(quoteId: "some", passengers: mockPassengers)
        let tripBooked = TripInfoMock().set(tripId: "some").build()

        var capturedCallback: Result<TripInfo>?
        testObject.book(tripBooking: tripBooking).execute(callback: { capturedCallback = $0 })

        mockTripBookingInteractor.triggerSuccess(result: tripBooked)

        XCTAssertEqual(mockTripBookingInteractor.tripBookingSet!, tripBooking)
        XCTAssertEqual(tripBooked.tripId, capturedCallback!.getSuccessValue()!.tripId)
    }

    /**
     *  Given: Request failed
     *  When:  Booking a trip
     *  Then:  Error should be propagated through callback
     */
    func testBookingTripRequestFailure() {
        let tripBooking = TripBooking(quoteId: "some", passengers: mockPassengers)
        let expectedError = TestUtil.getRandomError()

        var capturedCallback: Result<TripInfo>?
        testObject.book(tripBooking: tripBooking).execute(callback: { capturedCallback = $0 })

        mockTripBookingInteractor.triggerFail(error: expectedError)

        XCTAssert(expectedError.equals(capturedCallback?.getErrorValue()))
    }

    /**
      * Given: Request succeeded
      * When: Getting trips
      * Then: List of trips should be returned in callback
      */
    func testGetTripsSuccess() {
        let tripList = [TripInfoMock().set(tripId: "some").build()]

        var capturedCallback: Result<[TripInfo]>?
        testObject.search(tripSearch: TripSearch()).execute(callback: { capturedCallback = $0 })

        mockTripSearchInteractor.triggerSuccess(result: tripList)

        XCTAssertEqual(tripList[0].tripId, capturedCallback!.getSuccessValue()![0].tripId)
    }

    /**
      * Given: request fails
      * When: Getting trips
      * Then: Error should be propogated through callback
      */
    func testGetTripsFail() {
        let expectedError = TestUtil.getRandomError()

        var capturedCallback: Result<[TripInfo]>?
        testObject.search(tripSearch: TripSearch()).execute(callback: { capturedCallback = $0 })

        mockTripSearchInteractor.triggerFail(error: expectedError)

        XCTAssert(expectedError.equals(capturedCallback?.getErrorValue()))
    }

    /**
     *  When:   Cancelling a trip
     *   Then:  expected Callback should be received
     */
    func testCancelTripSuccess() {

        var capturedCallback: Result<KarhooVoid>?
        testObject.cancel(tripCancellation: tripCancellationMock).execute(callback: { capturedCallback = $0 })

        mockCancelTripInteractor.triggerSuccess(result: KarhooVoid())

        XCTAssertTrue(capturedCallback!.isSuccess())
        XCTAssertNil(capturedCallback!.getErrorValue())
    }

    /**
     *  When:   Cancelling a trip
     *  Then:  expected Callback should be received
     */
    func testCancelTripFails() {
        let expectedError = TestUtil.getRandomError()

        var capturedCallback: Result<KarhooVoid>?
        testObject.cancel(tripCancellation: tripCancellationMock).execute(callback: { capturedCallback = $0 })

        mockCancelTripInteractor.triggerFail(error: expectedError)

        XCTAssertFalse(capturedCallback!.isSuccess())
        XCTAssert(expectedError.equals(capturedCallback!.getErrorValue()))
    }

    /**
     * When: adding a track trip observer
     * Then: trackTripPollFactory should be called
     */
    func testTrackTrip() {
        let expectedTripId = "12345"
        _ = testObject.trackTrip(identifier: expectedTripId)

        XCTAssertNotNil(mocktripPollFactory.executableSet)
        XCTAssertEqual(expectedTripId, mocktripPollFactory.identifierSet)
    }

    /**
     * When: adding a track trip status observer
     * Then: trackTripPollFactory should be called
     */
    func testTrackTripStatus() {
        let expectedTripId = "12345"
        _ = testObject.status(tripId: expectedTripId)

        XCTAssertNotNil(mocktripStatusPollFactory.executableSet)
        XCTAssertEqual(expectedTripId, mocktripStatusPollFactory.identifierSet)
    }
    
    /**
     * When: Getting a cancellation fee
     * Then: Cancellation fee should be called
     */
    func testCancellationFeeSuccess() {
        let expectedTripId = "12345"
        _ = testObject.cancellationFee(identifier: expectedTripId)

        XCTAssertEqual(expectedTripId, mockCancellationFeeInteractor.identifierSet)
    }
    
    /**
     * When: Getting a cancellation fee
     * Then: Cancellation fee should be called
     */
    func testCancellationFeeFailure() {
        let expectedTripId = "12345"
        _ = testObject.cancellationFee(identifier: expectedTripId)
        let expectedError = TestUtil.getRandomError()
        
        mockCancellationFeeInteractor.triggerFail(error: expectedError)
        XCTAssertEqual(expectedTripId, mockCancellationFeeInteractor.identifierSet)
    }
    
}
