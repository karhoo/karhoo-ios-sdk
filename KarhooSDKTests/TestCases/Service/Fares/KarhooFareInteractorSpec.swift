//
//  FareInteractorSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest

@testable import KarhooSDK

final class KarhooFareInteractorSpec: XCTestCase {
    
    private var testObject: KarhooFareInteractor!
    let tripId = "some_tripId"
    private var mockFareRequest: MockRequestSender!
    
    override func setUp() {
        super.setUp()
        
        mockFareRequest = MockRequestSender()
        testObject = KarhooFareInteractor(requestSender: mockFareRequest)
        testObject.set(tripId: tripId)
    }
    
    /**
     Given: Fare succeeds
     Then: Callback should be success
     */
    func testFareSuccess() {
        
        let expectedResponse = Fare(state: "some string", breakdown: FareComponent(total: 20, currency: "GBP"))
        var expectedResult: Result<Fare>?
        
        testObject.execute(callback: { expectedResult = $0})

        mockFareRequest.triggerSuccessWithDecoded(value: expectedResponse)
        
        XCTAssertEqual(expectedResponse.encode(), expectedResult!.getSuccessValue()!.encode()!)
        XCTAssertEqual(expectedResult?.getSuccessValue()!.breakdown.currency, "GBP")
        XCTAssertEqual(expectedResult?.getSuccessValue()!.breakdown.total, 20)
        XCTAssertTrue(expectedResult!.isSuccess())
        XCTAssertNil(expectedResult!.getErrorValue())
    }
    
    /**
     Given: Fare fails
     Then: Callback should contain expected error
     */
    func testFareFails() {
        let expectedError = TestUtil.getRandomError()

        var expectedResult: Result<Fare>?

        testObject.execute(callback: { expectedResult = $0})

        mockFareRequest.triggerFail(error: expectedError)

        XCTAssertNil(expectedResult?.getSuccessValue())
        XCTAssertFalse(expectedResult!.isSuccess())
        XCTAssert(expectedError.equals(expectedResult!.getErrorValue()!))
    }
}
