//
//  KarhooUIConfigProvider.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooUIConfigProvider: UIConfigProvider {

    func fetchConfig(uiConfigRequest: UIConfigRequest,
                     organisation: Organisation,
                     callback: CallbackClosure<UIConfig>) {
        if let config = UISettings.settings[organisation.id]?[uiConfigRequest.viewId ?? ""] {
            callback(Result.success(result: config))
        } else {
            callback(Result.failure(error: SDKErrorFactory.noConfigAvailableForView()))
        }
    }
}
