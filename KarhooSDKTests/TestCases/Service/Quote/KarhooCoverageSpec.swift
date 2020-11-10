//
//  KarhooCoverageSpec.swift
//  KarhooSDKTests
//
//  Created by Nurseda Balcioglu on 10/11/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

final class KarhooCoverageSpec: XCTestCase {

    private var testobject: KarhooQuoteService!
    private var mockCoverageInteractor = MockCoverageInteractor()
    
    private let mockCoverage: CoverageRequest = CoverageRequest(latitude: "", longitude: "", localTimeOfPickup: "")
    
    let mockCoverageResult = Coverage(coverage: true)


    override func setUp() {
        super.setUp()

        mockCoverageInteractor = MockCoverageInteractor()

        testobject = KarhooQuoteService(coverageInteractor: mockCoverageInteractor)
    }

    /**
      * When: Quote search succeeds
      * Then: callback should be executed with expected value
      */
    func testCoverageSucces() {
        let call = testobject.coverage(coverageRequest: mockCoverage)

        var result: Result<Coverage>?
        call.execute(callback: { result = $0 })

        mockCoverageInteractor.triggerSuccess(result: mockCoverageResult)
        XCTAssertTrue(result!.isSuccess())
    }

    /**
     * When: Quote search fails
     * Then: callback should be executed with expected value
     */
    func testCoverageFails() {
        let call = testobject.coverage(coverageRequest: mockCoverage)

        var result: Result<Coverage>?
        call.execute(callback: { result = $0 })

        let expectedError = TestUtil.getRandomError()
        mockCoverageInteractor.triggerFail(error: expectedError)

        XCTAssert(expectedError.equals(result?.errorValue()))
    }
}
