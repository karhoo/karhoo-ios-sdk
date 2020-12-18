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
    
    init(loyaltyBalanceInteractor: LoyaltyBalanceInteractor = KarhooLoyaltyBalanceInteractor(),
         loyaltyConversionInteractor: LoyaltyConversionInteractor = KarhooLoyaltyConversionInteractor()) {
        self.loyaltyBalanceInteractor = loyaltyBalanceInteractor
        self.loyaltyConversionInteractor = loyaltyConversionInteractor
    }
    
    func getLoyaltyBalance(identifier: String) -> Call<LoyaltyBalance> {
        loyaltyBalanceInteractor.set(identifier: identifier)
        return Call(executable: loyaltyBalanceInteractor)
    }
    
    func getLoyaltyConversion(identifier: String) -> Call<LoyaltyConversion> {
        loyaltyConversionInteractor.set(identifier: identifier)
        return Call(executable: loyaltyConversionInteractor)
    }
}
