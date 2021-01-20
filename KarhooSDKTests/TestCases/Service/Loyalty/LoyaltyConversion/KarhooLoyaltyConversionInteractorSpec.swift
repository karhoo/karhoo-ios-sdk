//
//  KarhooLoyaltyConversionInteractorSpec.swift
//  KarhooSDKTests
//
//  Created by Nurseda Balcioglu on 18/12/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

final class KarhooLoyaltyConversionInteractorSpec: XCTestCase {

    private var mockLoyaltyConversionRequest: MockRequestSender!
    private var testObject: KarhooLoyaltyConversionInteractor!

    private let identifier = "some_id"
    static let ratesMock = LoyaltyRates(currency: "GBP", points: "10")
    private let loyaltyConversionMock = LoyaltyConversion(version: "20200312", rates: [ratesMock])
    
    override func setUp() {
        super.setUp()
        
        mockLoyaltyConversionRequest = MockRequestSender()
        
        testObject = KarhooLoyaltyConversionInteractor(requestSender: mockLoyaltyConversionRequest)
        testObject.set(identifier: identifier)
    }
    
    /**
     * When: Making a request to loyalty conversion
     * Then: Expected method, path and payload should be set
     */

    func testRequestFormat() {
        testObject.execute(callback: { (_:Result<LoyaltyConversion>) in  })

        let endpoint = APIEndpoint.loyaltyConversion(identifier: identifier)

        mockLoyaltyConversionRequest.assertRequestSendAndDecoded(endpoint: endpoint,
                                                               method: .get,
                                                               payload: nil)
    }
    
    /**
      * Given: Requesting loyalty conversion for a trip
      * When: The request succeeds with a loyalty conversion burnable false
      * Then: Callback should be a success with a loyalty conversion result
      */
    func testRequestSuccess() {
        var capturedCallback: Result<LoyaltyConversion>?
        testObject.execute(callback: { capturedCallback = $0 })
        
        let rates = [KarhooLoyaltyConversionInteractorSpec.ratesMock]
        let loyaltyConversion = LoyaltyConversion(version: "20200312", rates: rates)
        mockLoyaltyConversionRequest.triggerSuccessWithDecoded(value: loyaltyConversion)
        
        XCTAssertEqual(capturedCallback!.successValue()!.version, "20200312")
        XCTAssertEqual(capturedCallback!.successValue()!.rates[0].currency, "GBP")
        XCTAssertEqual(capturedCallback!.successValue()!.rates[0].points, "10")
    }

    /**
      * Given: Requesting loyalty conversion for a trip
      * When: The request fails
      * Then: Callback should be a fail with expected error
      */
    func testRequestFailure() {
        let expectedError = TestUtil.getRandomError()

        var capturedCallback: Result<LoyaltyConversion>?
        testObject.execute(callback: { capturedCallback = $0 })

        mockLoyaltyConversionRequest.triggerFail(error: expectedError)

        XCTAssert(expectedError.equals(capturedCallback!.errorValue()))
    }

    /**
      * When: Cancelling the request for loyalty conversion
      * Then: Loyalty conversion request should cancel
      */
    func testCancelRequest() {
        testObject.cancel()
        XCTAssertTrue(mockLoyaltyConversionRequest.cancelNetworkRequestCalled)
    }
}

