//
//  PaymentProviderSpec.swift
//  KarhooSDKIntegrationTests
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import XCTest
@testable import KarhooSDK

final class PaymentProviderSpec: XCTestCase {

    private var paymentService: PaymentService!
    private let path: String = "/v3/payments/providers"
    private var call: Call<PaymentProvider>!
    
    override func setUp() {
        super.setUp()
        
        paymentService = KarhooPaymentService()
        
        call = paymentService.getPaymentProvider()
    }
    
    /**
     * When: Getting the payment provider
     * And: The response returns successful
     * Then: Result is success
     */
    func testHappyPath() {
        NetworkStub.successResponse(jsonFile: "PaymentProvider.json", path: path)
        
        let expectation = self.expectation(description: "Callback called with succeess")
        
        call.execute(callback: { result in
            XCTAssertEqual("Adyen", result.successValue()?.provider.id)
            XCTAssertEqual(PaymentProviderType.adyen, result.successValue()?.provider.type)
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 100)
    }
    
    /**
     * When: Getting the payment provider
     * And: The response returns error K0001
     * Then: Resulting error value should be a generalRequestError
     */
    func testErrorResponse() {
        let expectedError = RawKarhooErrorFactory.buildError(code: "K0001")

        NetworkStub.errorResponse(path: path, responseData: expectedError)

        let expectation = self.expectation(description: "calls callback with error result")

        call.execute(callback: { result in
            XCTAssertEqual(.generalRequestError, result.errorValue()!.type)
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10)
    }
    
    /**
     * When: Getting the payment provider
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
        
        waitForExpectations(timeout: 10)
    }
    
}
