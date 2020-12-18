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
    
    init(loyaltyBalanceInteractor: LoyaltyBalanceInteractor = KarhooLoyaltyBalanceInteractor()) {
        self.loyaltyBalanceInteractor = loyaltyBalanceInteractor
    }
    
    func getLoyaltyBalance(identifier: String) -> Call<LoyaltyBalance> {
        loyaltyBalanceInteractor.set(identifier: identifier)
        return Call(executable: loyaltyBalanceInteractor)
    }
}
