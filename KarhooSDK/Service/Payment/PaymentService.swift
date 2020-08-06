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
}
