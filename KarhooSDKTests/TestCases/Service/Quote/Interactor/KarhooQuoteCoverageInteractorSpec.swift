//
//  KarhooQuoteCoverageInteractorSpec.swift
//  KarhooSDKTests
//
//  Created by Nurseda Balcioglu on 10/11/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

final class KarhooQuoteCoverageInteractorSpec: XCTestCase {

    private var testObject: KarhooQuoteCoverageInteractor!
    private var mockQuoteCoverageRequest: MockRequestSender!
    private var mockPayload: QuoteCoverageRequest!

    override func setUp() {
        super.setUp()

        mockQuoteCoverageRequest = MockRequestSender()
        
        mockPayload = QuoteCoverageRequest(latitude: "123", longitude: "456", localTimeOfPickup: "10.00")
        
        testObject = KarhooQuoteCoverageInteractor(requestSender: mockQuoteCoverageRequest)
        
        testObject.set(coverageRequest: mockPayload)
    }
    
    /**
     * When: Calling quote coverage
     * Then: Expected method, path and payload should be set
     */
    func testRequestFormat() {
        testObject.execute(callback: { response in
            _ = response as Result<QuoteCoverage>
        })

        mockQuoteCoverageRequest.assertRequestSendAndDecoded(endpoint: .quoteCoverage,
                                                              method: .get,
                                                              payload: mockPayload)
    }

    /**
     * Given: Calling execute
     * When: The interactor sends a coverage request
     * Then: Response of true or false should come back
     */
    func testQuoteCoverageRequestSucceeds() {
        var result: Result<QuoteCoverage>?
        testObject.execute(callback: { result = $0 })

        mockQuoteCoverageRequest.triggerSuccessWithDecoded(value: QuoteCoverage(coverage: true))

        XCTAssertTrue(result!.isSuccess())
    }
    
    /**
     * Given: Calling execute
     * When: The request fails
     * Then: Callback should contain expected error
     */
    func testQuoteCoverageRequestFails() {
        var response: Result<QuoteCoverage>?
        testObject.execute(callback: { result in
            response = result
        })

        let expectedError = TestUtil.getRandomError()
        mockQuoteCoverageRequest.triggerFail(error: expectedError)

        XCTAssert(expectedError.equals(response!.errorValue()))
    }
}
