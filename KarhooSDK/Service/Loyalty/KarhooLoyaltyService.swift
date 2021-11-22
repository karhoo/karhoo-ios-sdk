//
//  KarhooLoyaltyService.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 17/12/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooLoyaltyService: LoyaltyService {
    private let loyaltyBalanceInteractor: LoyaltyBalanceInteractor
    private let loyaltyConversionInteractor: LoyaltyConversionInteractor
    private let loyaltyStatusInteractor: LoyaltyStatusInteractor
    private let loyaltyBurnInteractor: LoyaltyBurnInteractor
    private let loyaltyEarnInteractor: LoyaltyEarnInteractor
    private let loyaltyPreAuthInteractor: LoyaltyPreAuthInteractor
    
    init(loyaltyBalanceInteractor: LoyaltyBalanceInteractor = KarhooLoyaltyBalanceInteractor(),
         loyaltyConversionInteractor: LoyaltyConversionInteractor = KarhooLoyaltyConversionInteractor(),
         loyaltyStatusInteractor: LoyaltyStatusInteractor = KarhooLoyaltyStatusInteractor(),
         loyaltyBurnInteractor: LoyaltyBurnInteractor = KarhooLoyaltyBurnInteractor(),
         loyaltyEarnInteractor: LoyaltyEarnInteractor = KarhooLoyaltyEarnInteractor(),
         loyaltyPreAuthInteractor: LoyaltyPreAuthInteractor = KarhooLoyaltyPreAuthInteractor()) {
        self.loyaltyBalanceInteractor = loyaltyBalanceInteractor
        self.loyaltyConversionInteractor = loyaltyConversionInteractor
        self.loyaltyStatusInteractor = loyaltyStatusInteractor
        self.loyaltyBurnInteractor = loyaltyBurnInteractor
        self.loyaltyEarnInteractor = loyaltyEarnInteractor
        self.loyaltyPreAuthInteractor = loyaltyPreAuthInteractor
    }
    
    func getLoyaltyBalance(identifier: String) -> Call<LoyaltyBalance> {
        loyaltyBalanceInteractor.set(identifier: identifier)
        return Call(executable: loyaltyBalanceInteractor)
    }
    
    func getLoyaltyConversion(identifier: String) -> Call<LoyaltyConversion> {
        loyaltyConversionInteractor.set(identifier: identifier)
        return Call(executable: loyaltyConversionInteractor)
    }
    
    func getLoyaltyStatus(identifier: String) -> Call<LoyaltyStatus> {
        loyaltyStatusInteractor.set(identifier: identifier)
        return Call(executable: loyaltyStatusInteractor)
    }
    
    func getLoyaltyBurn(identifier: String, currency: String, amount: Int) -> Call<LoyaltyPoints> {
        loyaltyBurnInteractor.set(identifier: identifier,
                                  currency: currency,
                                  amount: amount)
        return Call(executable: loyaltyBurnInteractor)
    }
    
    func getLoyaltyEarn(identifier: String, currency: String, amount: Int, burnPoints: Int) -> Call<LoyaltyPoints> {
        loyaltyEarnInteractor.set(identifier: identifier,
                                  currency: currency,
                                  amount: amount,
                                  burnPoints: burnPoints)
        return Call(executable: loyaltyEarnInteractor)
    }
    
    func getLoyaltyPreAuth(preAuthRequest: LoyaltyPreAuth) -> Call<LoyaltyNonce> {
        loyaltyPreAuthInteractor.set(loyaltyPreAuth: preAuthRequest)
        return Call(executable: loyaltyPreAuthInteractor)
    }
}
