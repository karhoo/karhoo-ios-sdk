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
}
