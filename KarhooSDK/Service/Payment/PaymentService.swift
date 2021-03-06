//
//  PaymentService.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public protocol PaymentService {

    func initialisePaymentSDK(paymentSDKTokenPayload: PaymentSDKTokenPayload) -> Call<PaymentSDKToken>

    func getNonce(nonceRequestPayload: NonceRequestPayload) -> Call<Nonce>

    func addPaymentDetails(addPaymentDetailsPayload: AddPaymentDetailsPayload) -> Call<Nonce>
    
    func getPaymentProvider() -> Call<PaymentProvider>
    
    func adyenPaymentMethods(request: AdyenPaymentMethodsRequest) -> Call<DecodableData>
    
    func adyenPayments(request: AdyenPaymentsRequest) -> Call<AdyenPayments>
    
    func getAdyenPaymentDetails(paymentDetails: PaymentsDetailsRequestPayload) -> Call<DecodableData>
    
    func getAdyenPublicKey() -> Call<AdyenPublicKey>
}
