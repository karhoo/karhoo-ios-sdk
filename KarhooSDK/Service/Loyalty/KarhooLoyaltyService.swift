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
    
    init(loyaltyBalanceInteractor: LoyaltyBalanceInteractor = KarhooLoyaltyBalanceInteractor(),
         loyaltyConversionInteractor: LoyaltyConversionInteractor = KarhooLoyaltyConversionInteractor(),
         loyaltyStatusInteractor: LoyaltyStatusInteractor = KarhooLoyaltyStatusInteractor(),
         loyaltyBurnInteractor: LoyaltyBurnInteractor = KarhooLoyaltyBurnInteractor(),
         loyaltyEarnInteractor: LoyaltyEarnInteractor = KarhooLoyaltyEarnInteractor()) {
        self.loyaltyBalanceInteractor = loyaltyBalanceInteractor
        self.loyaltyConversionInteractor = loyaltyConversionInteractor
        self.loyaltyStatusInteractor = loyaltyStatusInteractor
        self.loyaltyBurnInteractor = loyaltyBurnInteractor
        self.loyaltyEarnInteractor = loyaltyEarnInteractor
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
    
    func geyLoyaltyEarn(identifier: String, currency: String, amount: Int, points: Int) -> Call<LoyaltyPoints> {
        loyaltyEarnInteractor.set(identifier: identifier,
                                  currency: currency,
                                  amount: amount,
                                  points: points)
        return Call(executable: loyaltyEarnInteractor)
    }
}
