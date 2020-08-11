//
//  KarhooPaymentService.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooPaymentService: PaymentService {

    private let paymentSDKTokenInteractor: PaymentSDKTokenInteractor
    private let getNonceInteractor: GetNonceInteractor
    private let addPaymentDetailsInteractor: AddPaymentDetailsInteractor
    private let paymentProviderInteractor: PaymentProviderInteractor

    init(tokenInteractor: PaymentSDKTokenInteractor = KarhooPaymentSDKTokenInteractor(),
         getNonceInteractor: GetNonceInteractor = KarhooGetNonceInteractor(),
         addPaymentDetailsInteractor: AddPaymentDetailsInteractor = KarhooAddPaymentDetailsInteractor(),
         paymentProviderInteractor: PaymentProviderInteractor = KarhooPaymentProviderInteractor()) {
        self.paymentSDKTokenInteractor = tokenInteractor
        self.getNonceInteractor = getNonceInteractor
        self.addPaymentDetailsInteractor = addPaymentDetailsInteractor
        self.paymentProviderInteractor = paymentProviderInteractor
    }

    func initialisePaymentSDK(paymentSDKTokenPayload: PaymentSDKTokenPayload) -> Call<PaymentSDKToken> {
        paymentSDKTokenInteractor.set(payload: paymentSDKTokenPayload)

        return Call(executable: paymentSDKTokenInteractor)
    }

    func addPaymentDetails(addPaymentDetailsPayload: AddPaymentDetailsPayload) -> Call<Nonce> {
        addPaymentDetailsInteractor.set(addPaymentDetailsPayload: addPaymentDetailsPayload)

        return Call(executable: addPaymentDetailsInteractor)
    }

    func getNonce(nonceRequestPayload: NonceRequestPayload) -> Call<Nonce> {
        getNonceInteractor.set(nonceRequestPayload: nonceRequestPayload)
        return Call(executable: getNonceInteractor)
    }
    
    func getPaymentProvider() -> Call<PaymentProvider> {
        return Call(executable: paymentProviderInteractor)
    }
}
