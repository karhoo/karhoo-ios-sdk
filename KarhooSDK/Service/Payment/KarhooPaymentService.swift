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
    private let adyenPaymentsDetailsInteractor: AdyenPaymentsDetailsInteractor
    private let adyenPublicKeyInteractor: AdyenPublicKeyInteractor
    private let adyenClientKeyInteractor: AdyenClientKeyInteractor

    init(tokenInteractor: PaymentSDKTokenInteractor = KarhooPaymentSDKTokenInteractor(),
         getNonceInteractor: GetNonceInteractor = KarhooGetNonceInteractor(),
         addPaymentDetailsInteractor: AddPaymentDetailsInteractor = KarhooAddPaymentDetailsInteractor(),
         paymentProviderInteractor: PaymentProviderInteractor = KarhooPaymentProviderInteractor(),
         adyenPaymentMethodsInteractor: AdyenPaymentMethodsInteractor = KarhooAdyenPaymentMethodsInteractor(),
         adyenPaymentsInteractor: AdyenPaymentsInteractor = KarhooAdyenPaymentsInteractor(),
         adyenPaymentsDetailsInteractor: AdyenPaymentsDetailsInteractor = KarhooAdyenPaymentsDetailsInteractor(),
         adyenPublicKeyInteractor: AdyenPublicKeyInteractor = KarhooAdyenPublicKeyInteractor(),
         adyenClientKeyInteractor: AdyenClientKeyInteractor = AdyenClientKeyInteractor()){
        self.paymentSDKTokenInteractor = tokenInteractor
        self.getNonceInteractor = getNonceInteractor
        self.addPaymentDetailsInteractor = addPaymentDetailsInteractor
        self.paymentProviderInteractor = paymentProviderInteractor
        self.adyenPaymentMethodsInteractor = adyenPaymentMethodsInteractor
        self.adyenPaymentsInteractor = adyenPaymentsInteractor
        self.adyenPaymentsDetailsInteractor = adyenPaymentsDetailsInteractor
        self.adyenPublicKeyInteractor = adyenPublicKeyInteractor
        self.adyenClientKeyInteractor = adyenClientKeyInteractor
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
    
    func adyenPaymentMethods(request: AdyenPaymentMethodsRequest) -> Call<DecodableData> {
        adyenPaymentMethodsInteractor.set(request: request)
        return Call(executable: adyenPaymentMethodsInteractor)
    }
    
    func adyenPayments(request: AdyenPaymentsRequest) -> Call<AdyenPayments> {
        adyenPaymentsInteractor.set(request: request)
        return Call(executable: adyenPaymentsInteractor)
    }
    
    func getAdyenPaymentDetails(paymentDetails: PaymentsDetailsRequestPayload) -> Call<DecodableData> {
        adyenPaymentsDetailsInteractor.set(paymentsDetails: paymentDetails)
        return Call(executable: adyenPaymentsDetailsInteractor)
    }
    
    func getAdyenPublicKey() -> Call<AdyenPublicKey> {
        return Call(executable: adyenPublicKeyInteractor)
    }

    func getAdyenClientKey() -> Call<AdyenClientKey> {
        Call(executable: adyenClientKeyInteractor)
    }
}
