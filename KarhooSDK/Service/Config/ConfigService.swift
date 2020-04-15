//
//  ConfigurationService.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public protocol ConfigService {
    func uiConfig(uiConfigRequest: UIConfigRequest) -> Call<UIConfig>
}
