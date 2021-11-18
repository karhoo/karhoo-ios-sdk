//
//  LoyaltyService.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 17/12/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public protocol LoyaltyService {
    func getLoyaltyBalance(identifier: String) -> Call<LoyaltyBalance>
    
    func getLoyaltyConversion(identifier: String) -> Call<LoyaltyConversion>
    
    func getLoyaltyStatus(identifier: String) -> Call<LoyaltyStatus>
    
    func getLoyaltyBurn(identifier: String, currency: String, amount: Int) -> Call<LoyaltyPoints>
    
    func getLoyaltyEarn(identifier: String, currency: String, amount: Int, points: Int) -> Call<LoyaltyPoints>
    
    func getLoyaltyPreAuth(preAuthPayload: LoyaltyPreAuthPayload) -> Call<LoyaltyNonce>
}
