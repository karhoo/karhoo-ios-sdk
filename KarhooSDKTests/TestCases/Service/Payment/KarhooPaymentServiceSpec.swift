//
//  KarhooPaymentServiceSpec.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest

@testable import KarhooSDK

class KarhooPaymentServiceSpec: XCTestCase {

    private var mockPaymentSDKTokenInteractor: MockPaymentSDKTokenInteractor!
    private var mockGetNonceInteractor: MockGetNonceInteractor!
    private var mockAddPaymentDetailsInteractor: MockAddPaymentDetailsInteractor!
    private var mockPaymentProviderInteractor = MockPaymentProviderInteractor()
    private var mockAdyenPaymentMethodsInteractor = MockAdyenPaymentMethodsInteractor()
    private var testObject: KarhooPaymentService!
    private let mockRequestPayload: PaymentSDKTokenPayload = PaymentSDKTokenPayload(organisationId: "some",
                                                                                    currency: "gbp")
    override func setUp() {
        super.setUp()

        mockPaymentSDKTokenInteractor = MockPaymentSDKTokenInteractor()
        mockGetNonceInteractor = MockGetNonceInteractor()
        mockAddPaymentDetailsInteractor = MockAddPaymentDetailsInteractor()

        testObject = KarhooPaymentService(tokenInteractor: mockPaymentSDKTokenInteractor,
                                          getNonceInteractor: mockGetNonceInteractor,
                                          addPaymentDetailsInteractor: mockAddPaymentDetailsInteractor,
                                          paymentProviderInteractor: mockPaymentProviderInteractor,
                                          adyenPaymentMethodsInteractor: mockAdyenPaymentMethodsInteractor)
    }

    /**
     *  When:   paymentSDKTokenInteractor succeeds
     *  Then:   succeess value should be propogated through callback
     */
    func testPaymentSDKTokenInteractorSucceeds() {
        let karhooCall = testObject.initialisePaymentSDK(paymentSDKTokenPayload: mockRequestPayload)

        let mockResponse = PaymentSDKToken(token: "this is the return token")

        var executeResult: Result<PaymentSDKToken>?
        karhooCall.execute(callback: { result in
            executeResult = result
        })

        mockPaymentSDKTokenInteractor.triggerSuccess(result: mockResponse)
        XCTAssertTrue(executeResult!.isSuccess())
        XCTAssertEqual(mockResponse.token, executeResult?.getSuccessValue()?.token)
    }

    /**
     *  When:   Client token fetch fails
     *  Then:   An error should be sent through the callback
     */
    func testTokenFetchFails() {
        let karhooCall = testObject.initialisePaymentSDK(paymentSDKTokenPayload: mockRequestPayload)

        var executeResult: Result<PaymentSDKToken>?
        karhooCall.execute(callback: { result in
            executeResult = result
        })

        let error = TestUtil.getRandomError()
        mockPaymentSDKTokenInteractor.triggerFail(error: error)

        XCTAssert(error.equals(executeResult!.getErrorValue()!))
        XCTAssertNil(executeResult?.getSuccessValue()?.token)
    }

    /**
     * Given:   Get nonce is called
     *  When:   getNonceInteractor succeeds
     *  Then:   succeess value should be propogated through callback
     */
    func testGetNonceSuccess() {
        let mockPayload = NonceRequestPayloadMock().set(payer: Payer()).set(organisationId: "some").build()
        let karhooCall = testObject.getNonce(nonceRequestPayload: mockPayload)

        let mockNonceResponse = Nonce(nonce: "some_nonce")

        var executeResult: Result<Nonce>?
        karhooCall.execute(callback: { result in
            executeResult = result
        })

        mockGetNonceInteractor.triggerSuccess(result: mockNonceResponse)

        XCTAssertTrue(executeResult!.isSuccess())
        XCTAssertEqual(mockNonceResponse.nonce, executeResult?.getSuccessValue()?.nonce)
    }

    /**
     * Given:   Get nonce is called
     *  When:   getNonceInteractor fails
     *  Then:   An error should be sent through the callback
     */
    func testGetNonceFail() {
        let mockPayload = NonceRequestPayloadMock().set(payer: Payer()).set(organisationId: "some").build()
        let karhooCall = testObject.getNonce(nonceRequestPayload: mockPayload)

        var executeResult: Result<Nonce>?
        karhooCall.execute(callback: { result in
            executeResult = result
        })

        let error = TestUtil.getRandomError()
        mockGetNonceInteractor.triggerFail(error: error)

        XCTAssert(error.equals(executeResult!.getErrorValue()!))
        XCTAssertNil(executeResult?.getSuccessValue()?.nonce)
    }

    /**
     *  When:   Adding payment details succeeds
     *  Then:   A success response should be sent through the callback
     */
    func testAddPaymentDetailsSuccessful() {
        let mockPayload = AddPaymentDetailsPayload(nonce: "some_nonce",
                                                   payer: Payer(),
                                                   organisationId: "some_orh")
        let karhooCall = testObject.addPaymentDetails(addPaymentDetailsPayload: mockPayload)

        var executeResult: Result<Nonce>?
        karhooCall.execute(callback: { result in
            executeResult = result
        })

        mockAddPaymentDetailsInteractor.triggerSuccess(result: Nonce(nonce: "some+token"))

        XCTAssertEqual("some+token", executeResult?.getSuccessValue()?.nonce)
    }

    /**
     *  When:   Adding payment details fails
     *  Then:   An error should be sent through the callback
     */
    func testAddPaymentDetailsFail() {
        let mockPayload = AddPaymentDetailsPayload(nonce: "some_nonce",
                                                   payer: Payer(),
                                                   organisationId: "some_orh")

        let karhooCall = testObject.addPaymentDetails(addPaymentDetailsPayload: mockPayload)

        var executeResult: Result<Nonce>?
        karhooCall.execute(callback: { result in
            executeResult = result
        })

        let error = TestUtil.getRandomError()
        mockAddPaymentDetailsInteractor.triggerFail(error: error)

        XCTAssert(error.equals(executeResult!.getErrorValue()!))
    }

    /**
     *  When:   Getting payment provider succeeds
     *  Then:   A success response should be sent through the callback
     */
    func testGetPaymentProviderSuccessful() {
        let karhooCall = testObject.getPaymentProvider()

        var executeResult: Result<PaymentProvider>?
        karhooCall.execute(callback: { result in
            executeResult = result
        })

        mockPaymentProviderInteractor.triggerSuccess(result: PaymentProvider(provider: Provider(id: "braintree")))

        XCTAssertEqual(executeResult?.getSuccessValue()?.provider.type, .braintree)
    }

    /**
     *  When:   Getting payment provider  fails
     *  Then:   An error should be sent through the callback
     */
    func testGetPaymentProviderFail() {
        let karhooCall = testObject.getPaymentProvider()

        var executeResult: Result<PaymentProvider>?
        karhooCall.execute(callback: { result in
            executeResult = result
        })

        let error = TestUtil.getRandomError()
        mockPaymentProviderInteractor.triggerFail(error: error)

        XCTAssert(error.equals(executeResult!.getErrorValue()!))
    }

    /** Note: This endpoint returns Data to be decoded by the Adyen Drop In SDK
     *  When:   Getting payment methods data succeeds
     *  Then:   A success response should be sent through the callback
     */
    func testAdyenPaymentMethodsSuccess() {
        let karhooCall = testObject.adyenPaymentMethods(request: AdyenPaymentMethodsRequest())

        var executeResult: Result<DecodableData>?
        karhooCall.execute(callback: { result in
            executeResult = result
        })

        mockAdyenPaymentMethodsInteractor.triggerSuccess(result: DecodableData(data: Data()))
        XCTAssertNotNil(mockAdyenPaymentMethodsInteractor.adyenPaymentMethodsRequest)
        XCTAssertEqual(executeResult?.getSuccessValue()?.data, Data())
    }

    /**
     *  When:   Getting payment provider  fails
     *  Then:   An error should be sent through the callback
     */
    func testAdyenPaymentMethodsFail() {
        let karhooCall = testObject.adyenPaymentMethods(request: AdyenPaymentMethodsRequest())

        var executeResult: Result<DecodableData>?
        karhooCall.execute(callback: { result in
            executeResult = result
        })

        let error = TestUtil.getRandomError()
        mockAdyenPaymentMethodsInteractor.triggerFail(error: error)

        XCTAssert(error.equals(executeResult!.getErrorValue()!))
    }
}
