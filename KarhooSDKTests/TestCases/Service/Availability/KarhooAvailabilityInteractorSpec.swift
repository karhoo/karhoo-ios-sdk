//
//  KarhooAvailabilityInteractorSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

final class KarhooAvailabilityInteractorSpec: XCTestCase {

    private var mockAvailabilityRequest: MockRequestSender!

    private var testObject: KarhooAvailabilityInteractor!
    private let mockSearch = AvailabilitySearch(origin: "origin",
                                                destination: "destination")

    override func setUp() {
        super.setUp()

        mockAvailabilityRequest = MockRequestSender()
        testObject = KarhooAvailabilityInteractor(request: mockAvailabilityRequest)
        testObject.set(availabilitySearch: mockSearch)
    }

    /**
     * When: Getting availability
     * Then: Expected method, path and payload should be set
     */
    func testRequestFormat() {
        testObject.execute(callback: { (_: Result<Categories>) in })

        mockAvailabilityRequest.assertRequestSendAndDecoded(endpoint: .availability,
                                                            method: .post,
                                                            payload: mockSearch)
    }

    /**
     * When: Request succeeds
     * Then: Callback should succeed with expexcted result
     */
    func testRequestSucceeds() {
        let expectedResponse = CategoriesMock().set(categories: ["first", "second", "third"])

        var result: Result<Categories>?
        testObject.execute(callback: { result = $0})

        mockAvailabilityRequest.triggerSuccessWithDecoded(value: expectedResponse.build())

        XCTAssertTrue(result!.isSuccess())
        XCTAssertTrue(expectedResponse.build().equals(result!.successValue()!))
    }

    /**
     * When: Request fails
     * Then: Callback should fail with expexcted error
     */
    func testRequestFails() {
        let error = TestUtil.getRandomError()

        var result: Result<Categories>?
        testObject.execute(callback: { result = $0 })

        mockAvailabilityRequest.triggerFail(error: error)

        XCTAssertFalse(result!.isSuccess())
        XCTAssertTrue(error.equals(result?.errorValue()!))
    }
}
