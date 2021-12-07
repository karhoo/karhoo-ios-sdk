//
//  LoyaltyBurnInteractor.swift
//  KarhooSDK
//
//  Created by Edward Wilkins on 17/11/2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

protocol LoyaltyBurnInteractor: KarhooExecutable {
    func set(identifier: String, currency: String, amount: Int)
}
