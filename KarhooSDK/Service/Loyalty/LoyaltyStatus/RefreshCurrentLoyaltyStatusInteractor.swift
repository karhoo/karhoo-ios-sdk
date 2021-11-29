//
//  RefreshLoyaltyStatusInteractor.swift
//  KarhooSDK
//
//  Created by Diana Petrea on 29.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

protocol RefreshCurrentLoyaltyStatusInteractor: KarhooExecutable {
    func set(identifier: String)
}
