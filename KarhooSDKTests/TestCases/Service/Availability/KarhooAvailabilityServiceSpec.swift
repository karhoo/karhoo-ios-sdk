//
//  KarhooAvailabilityServiceSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class KarhooAvailabilityServiceSpec: XCTestCase {

    private var mockAvailabilityInteractor: MockAvailabilityInteractor!
    private var testObject: KarhooAvailabilityService!
    private let mockSearch = AvailabilitySearch(origin: "origin", destination: "destination", dateScheduled: "date")

    override func setUp() {
        super.setUp()

        mockAvailabilityInteractor = MockAvailabilityInteractor()
        testObject = KarhooAvailabilityService(availabilityInteractor: mockAvailabilityInteractor)
    }

    /**
     *  When:   Getting availability
     *  Then:   Availability should be called and callback set
     */
    func testAvailabilityRequest() {
        testObject.availability(availabilitySearch: mockSearch).execute(callback: { _ in})

        XCTAssertTrue(mockSearch.equals(mockAvailabilityInteractor.setAvailabilitySearch!))
    }

    /**
     * When: Availability request is successful
     * Then: Callback should be successful
     * And: Callback should contain expected result
     */
    func testAvailabilityRequestSucceed() {
        var callbackResult: Result<Categories>?
        let karhooCall = testObject.availability(availabilitySearch: mockSearch)

        karhooCall.execute(callback: { callbackResult = $0 })

        let categories = Categories(categories: ["first", "second"])
        mockAvailabilityInteractor.triggerSuccess(result: categories)

        XCTAssertTrue(callbackResult!.isSuccess())
        XCTAssertNil(callbackResult?.errorValue())
        XCTAssertEqual(categories, callbackResult?.successValue())
    }

    /**
     * When: Request fails
     * Then: Callback should fail
     */
    func testAvailabilityRequestFails() {
        var callbackResult: Result<Categories>?
        let karhooCall = testObject.availability(availabilitySearch: mockSearch)

        karhooCall.execute(callback: { callbackResult = $0 })

        let expectedError = TestUtil.getRandomError()
        mockAvailabilityInteractor.triggerFail(error: expectedError)

        XCTAssertFalse(callbackResult!.isSuccess())
        XCTAssertNil(callbackResult?.successValue())
        XCTAssert(expectedError.equals(callbackResult!.errorValue()!))
    }
}
