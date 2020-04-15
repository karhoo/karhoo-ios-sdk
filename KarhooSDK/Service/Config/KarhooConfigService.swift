//
//  KarhooConfigService.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooConfigService: ConfigService {

    private let uiConfigInteractor: UIConfigInteractor

    init(uiConfigInteractor: UIConfigInteractor = KarhooUIConfigInteractor()) {
        self.uiConfigInteractor = uiConfigInteractor
    }

    func uiConfig(uiConfigRequest: UIConfigRequest) -> Call<UIConfig> {
        uiConfigInteractor.set(uiConfigRequest: uiConfigRequest)
        return Call(executable: uiConfigInteractor)
    }
}
