//
//  LoyaltyStatusInteractor.swift
//  KarhooSDK
//
//  Created by Edward Wilkins on 16/11/2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

protocol LoyaltyStatusInteractor: KarhooExecutableWithCorrelationId {
    func set(identifier: String)
}
