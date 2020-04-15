//
//  KarhooAddressServiceSpec.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
import CoreLocation

@testable import KarhooSDK

class KarhooAddressServiceSpec: XCTestCase {

    private var mockPlaceSearchInteractor: MockPlaceSearchInteractor!
    private var mockLocationInfoInteractor: MockLocationInfoInteractor!
    private var mockReverseGeocodeInteractor: MockReverseGeocodeInteractor!
    private var testObject: KarhooAddressService!
    private let mockPlaceSearch: PlaceSearch = PlaceSearch(position: Position(latitude: 51,
                                                                              longitude: 20),
                                                           query: "search",
                                                           sessionToken: "1234")
    private let testPostion = Position(latitude: 10, longitude: 10)

    override func setUp() {
        super.setUp()

        mockPlaceSearchInteractor = MockPlaceSearchInteractor()
        mockLocationInfoInteractor = MockLocationInfoInteractor()
        mockReverseGeocodeInteractor = MockReverseGeocodeInteractor()

        testObject = KarhooAddressService(placeSearchInteractor: mockPlaceSearchInteractor,
                                          locationInfoInteractor: mockLocationInfoInteractor,
                                          reverseGeocodeInteractor: mockReverseGeocodeInteractor)
    }

    /**
     *  Given: Searching for an address
     *  When:  The interactor succeeds
     *  Then:  Result should be propogated
     *  And:   Expected request should be set
     */
    func testAddressSearchSuccess() {
        let expectedResult = Places(places: [Place(placeId: "expectedPlaceId",
                                                   displayAddress: "some")])

        var capturedResult: Result<Places>?
        testObject.placeSearch(placeSearch: mockPlaceSearch).execute(callback: { capturedResult = $0 })

        mockPlaceSearchInteractor.triggerSuccess(result: expectedResult)

        XCTAssertEqual(capturedResult!.successValue()!.places[0].encode(),
                       expectedResult.places[0].encode())
        XCTAssertTrue(capturedResult!.isSuccess())
        XCTAssertNil(capturedResult?.errorValue())
        XCTAssertEqual(mockPlaceSearch, mockPlaceSearchInteractor.placeSearchSet!)
    }

    /**
     *  Given: Searching for an address
     *  When:  The interactor fails
     *  Then:  Result should be propogated
     *  And:   Expected request should be set
     */
    func testAddressSearchFails() {
        let expectedError = TestUtil.getRandomError()

        var capturedResult: Result<Places>?
        testObject.placeSearch(placeSearch: mockPlaceSearch).execute(callback: { capturedResult = $0 })

        mockPlaceSearchInteractor.triggerFail(error: expectedError)

        XCTAssertNil(capturedResult?.successValue())
        XCTAssertFalse(capturedResult!.isSuccess())
        XCTAssert(expectedError.equals(capturedResult!.errorValue()!))
        XCTAssertEqual(mockPlaceSearch, mockPlaceSearchInteractor.placeSearchSet!)
    }

    /**
     *  Given: Reverse geocoding a CLLocation
     *  When:  The interactor succeeds
     *  Then:  The expected LocationDetails result should be propogated
     *  And:   The right location should be set on the interactor
     */
    func testReverseGeocodeSucceeds() {
        let testPosition = Position(latitude: 14, longitude: 10)
        let expectedResult = LocationInfoMock().set(placeId: "some").build()

        var capturedResult: Result<LocationInfo>?
        testObject.reverseGeocode(position: testPosition).execute(callback: { capturedResult = $0 })

        mockReverseGeocodeInteractor.triggerSuccess(result: expectedResult)

        XCTAssertTrue(capturedResult!.isSuccess())
        XCTAssertNil(capturedResult?.errorValue())
        XCTAssertEqual(capturedResult!.successValue()?.encode(), expectedResult.encode())
        XCTAssertEqual(testPosition, mockReverseGeocodeInteractor.positionSet)
    }

    /**
     *  Given: Reverse geocoding a CLLocation
     *  When:  The interactor fails
     *  Then:  The expected error result should be propogated
     *  And:   The right location should be set on the interactor
     */
    func testReverseGeocodeFails() {
        let expectedError = TestUtil.getRandomError()

        var capturedResult: Result<LocationInfo>?
        testObject.reverseGeocode(position: testPostion).execute(callback: { capturedResult = $0 })

        mockReverseGeocodeInteractor.triggerFail(error: expectedError)

        XCTAssertFalse(capturedResult!.isSuccess())
        XCTAssertNil(capturedResult?.successValue())
        XCTAssert(expectedError.equals(capturedResult!.errorValue()!))
        XCTAssertEqual(mockReverseGeocodeInteractor.positionSet, testPostion)
    }

    /**
     *  Given: Getting LocationInfo for a placeId
     *  When:  The Interactor succeeds
     *  Then:  The expected LocationInfo result should be propogated
     *  And:   The right placeId should be set on the Interactor
     */
    func testGetLocationInfoSucceeds() {
        let expectedResult = LocationInfoMock().set(placeId: "some").build()

        var capturedResult: Result<LocationInfo>?
        testObject.locationInfo(locationInfoSearch: LocationInfoSearch(placeId: "123",
                                                                       sessionToken: "1234"))
            .execute(callback: { capturedResult = $0 })

        mockLocationInfoInteractor.triggerSuccess(result: expectedResult)

        XCTAssertTrue(capturedResult!.isSuccess())
        XCTAssertNil(capturedResult?.errorValue())
        XCTAssertEqual(capturedResult!.successValue()?.encode(), expectedResult.encode())
        XCTAssertEqual(mockLocationInfoInteractor.locationInfoSearchSet?.placeId, "123")
        XCTAssertEqual(mockLocationInfoInteractor.locationInfoSearchSet?.sessionToken, "1234")

    }

    /**
     *  Given: Getting LocationInfo for a place id
     *  When:  The interactor fails
     *  Then:  The expected error result should be propogated
     *  And:   The right place id should be set on the interactor
     */
    func testGetLocationInfoFails() {
        let expectedError = TestUtil.getRandomError()

        var capturedResponse: Result<LocationInfo>?
        testObject.locationInfo(locationInfoSearch: LocationInfoSearch(placeId: "123",
                                                                       sessionToken: "1234"))
            .execute(callback: { capturedResponse = $0 })
        mockLocationInfoInteractor.triggerFail(error: expectedError)

        XCTAssertFalse(capturedResponse!.isSuccess())
        XCTAssertNil(capturedResponse?.successValue())
        XCTAssert(expectedError.equals(capturedResponse!.errorValue()!))
        XCTAssertEqual(mockLocationInfoInteractor.locationInfoSearchSet?.placeId, "123")
        XCTAssertEqual(mockLocationInfoInteractor.locationInfoSearchSet?.sessionToken, "1234")
    }
}
