//
//  UIConfigProvider.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol UIConfigProvider {
    func fetchConfig(uiConfigRequest: UIConfigRequest,
                     organisation: Organisation,
                     callback: @escaping CallbackClosure<UIConfig>)
}
