//
//  LoyaltyUtils.swift
//  KarhooSDK
//
//  Created by Diana Petrea on 26.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

class LoyaltyUtils {
    
    static func updateLoyaltyStatusFor(paymentProvider: PaymentProvider?,
                                       userDataStore: UserDataStore,
                                       loyaltyProviderRequest: RequestSender) {
        guard let paymentProvider = paymentProvider,
              !paymentProvider.loyaltyProgamme.id.isEmpty,
              userDataStore.getLoyaltyStatusFor(loyaltyId: paymentProvider.loyaltyProgamme.id) == nil
        else {
            return
        }
        
        loyaltyProviderRequest.requestAndDecode(payload: nil,
                                                endpoint: .loyaltyStatus(identifier: paymentProvider.loyaltyProgamme.id),
                                                callback: { (result: Result<LoyaltyStatus>) in
            guard let status = result.getSuccessValue()
            else {
                return
            }
            
            userDataStore.updateLoyaltyStatus(status: status, forLoyaltyId: paymentProvider.loyaltyProgamme.id)
        })
    }
}
