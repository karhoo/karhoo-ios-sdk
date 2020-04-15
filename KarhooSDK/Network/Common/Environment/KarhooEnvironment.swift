//
//  KarhooEnvironment.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public enum KarhooEnvironment {
    case sandbox
    case production
    case custom(environment: KarhooEnvironmentDetails)
}
