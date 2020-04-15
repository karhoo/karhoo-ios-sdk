//
//  QuoteType.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public enum QuoteType: String, Codable {
    case fixed = "FIXED"
    case estimated = "ESTIMATED"
    case metered = "METERED"
}
