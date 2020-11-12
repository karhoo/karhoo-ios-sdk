//
//  AdyenPaymentMethodsSpec.swift
//  KarhooSDKIntegrationTests
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class AdyenPaymentMethodsSpec: XCTestCase {

    private var paymentService: PaymentService!
    private let path: String = "/v3/payments/adyen/payments-methods"
    private var call: Call<DecodableData>!
    
    override func setUp() {
        super.setUp()
        
        paymentService = KarhooPaymentService()
        
        call = paymentService.adyenPaymentMethods(request: AdyenPaymentMethodsRequest())
    }
    
    /**
     * When: Getting Adyen payment methods
     * And: The response returns successful
     * Then: Result is success
     */
    func testHappyPath() {
        NetworkStub.successResponse(jsonFile: "AdyenPaymentMethods.json", path: path)
        
        let expectation = self.expectation(description: "Callback called with succeess")
        
        call.execute(callback: { result in
            XCTAssertNotNil(result.successValue()!.data)
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10)
    }
    
    /**
     * When: Getting Adyen payment methods
     * And: The response returns error K0001
     * Then: Resulting error value should be a generalRequestError
     */
    func testErrorResponse() {
        let expectedError = RawKarhooErrorFactory.buildError(code: "K0001")

        NetworkStub.errorResponse(path: path, responseData: expectedError)

        let expectation = self.expectation(description: "calls callback with error result")

        call.execute(callback: { result in
            XCTAssertEqual(.generalRequestError, result.errorValue()!.type)
            XCTAssertNil(result.successValue())

            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 1)
    }
    
    /**
     * When: Getting Adyen payment methods
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
    
}
