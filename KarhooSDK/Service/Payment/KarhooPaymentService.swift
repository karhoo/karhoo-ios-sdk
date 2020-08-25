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
    private let adyenPaymentMethodsInteractor: AdyenPaymentMethodsInteractor
    private let adyenPaymentsInteractor: AdyenPaymentsInteractor

    init(tokenInteractor: PaymentSDKTokenInteractor = KarhooPaymentSDKTokenInteractor(),
         getNonceInteractor: GetNonceInteractor = KarhooGetNonceInteractor(),
         addPaymentDetailsInteractor: AddPaymentDetailsInteractor = KarhooAddPaymentDetailsInteractor(),
         paymentProviderInteractor: PaymentProviderInteractor = KarhooPaymentProviderInteractor(),
         adyenPaymentMethodsInteractor: AdyenPaymentMethodsInteractor = KarhooAdyenPaymentMethodsInteractor(),
    adyenPaymentsInteractor: AdyenPaymentsInteractor = KarhooAdyenPaymentsInteractor()){
        self.paymentSDKTokenInteractor = tokenInteractor
        self.getNonceInteractor = getNonceInteractor
        self.addPaymentDetailsInteractor = addPaymentDetailsInteractor
        self.paymentProviderInteractor = paymentProviderInteractor
        self.adyenPaymentMethodsInteractor = adyenPaymentMethodsInteractor
        self.adyenPaymentsInteractor = adyenPaymentsInteractor
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
    
    func getAdyenPaymentMethods() -> Call<AdyenPaymentMethods> {
        return Call(executable: adyenPaymentMethodsInteractor)
    }
    
    func getAdyenPayments() -> Call<AdyenPaymentsResponse> {
        return Call(executable: adyenPaymentsInteractor)
    }
    
}
