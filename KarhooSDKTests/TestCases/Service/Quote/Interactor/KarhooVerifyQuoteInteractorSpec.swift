//
//  KarhooVerifyQuoteInteractorSpec.swift
//  KarhooSDKTests
//
//  Created by Nurseda Balcioglu on 18/11/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

final class KarhooVerifyQuoteInteractorSpec: XCTestCase {

    private var testObject: KarhooVerifyQuoteInteractor!
    private var mockVerifyQuoteRequest: MockRequestSender!
    private var mockPayload: VerifyQuotePayload!
    
    private let mockFleet = FleetInfo(id: "success-quotev2")
    private lazy var mockQuote = QuoteMock().set(quoteId: "success-quote").set(categoryName: "foo").set(fleet: mockFleet).build()

    override func setUp() {
        super.setUp()

        mockVerifyQuoteRequest = MockRequestSender()
        
        mockPayload = VerifyQuotePayload(quoteID: "success-quote")
        
        testObject = KarhooVerifyQuoteInteractor(requestSender: mockVerifyQuoteRequest)
        
        testObject.set(verifyQuotePayload: mockPayload)
    }
    
    /**
     * When: Calling quote verify
     * Then: Expected method, path and payload should be set
     */
    func testRequestFormat() {
        testObject.execute(callback: { response in
            _ = response as Result<Quote>
        })

        mockVerifyQuoteRequest.assertRequestSendAndDecoded(endpoint: .verifyQuote(quoteID: "success-quote"),
                                                              method: .get,
                                                              payload: mockPayload)
    }

    /**
     * Given: Calling execute
     * When: The interactor sends a verify request
     * Then: Response of true or false should come back
     */
    func testQuoteCoverageRequestSucceeds() {
        var result: Result<Quote>?
        testObject.execute(callback: { result = $0 })

        mockVerifyQuoteRequest.triggerSuccessWithDecoded(value: mockQuote)

        XCTAssertTrue(result!.isSuccess())
    }
    
    /**
     * Given: Calling execute
     * When: The request fails
     * Then: Callback should contain expected error
     */
    func testQuoteCoverageRequestFails() {
        var response: Result<Quote>?
        testObject.execute(callback: { result in
            response = result
        })

        let expectedError = TestUtil.getRandomError()
        mockVerifyQuoteRequest.triggerFail(error: expectedError)

        XCTAssert(expectedError.equals(response!.errorValue()))
    }
}
