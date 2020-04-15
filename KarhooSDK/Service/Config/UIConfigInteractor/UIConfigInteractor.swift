//
//  ConfigInteractor.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol UIConfigInteractor: KarhooExecutable {
    func set(uiConfigRequest: UIConfigRequest)
}
