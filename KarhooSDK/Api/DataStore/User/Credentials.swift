//
//  Credentials.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct Credentials {
    let accessToken: String
    let expiryDate: Date?
    let refreshToken: String?
    
    init(accessToken: String, expiryDate: Date?, refreshToken: String?) {
        self.accessToken = accessToken
        self.expiryDate = expiryDate
        self.refreshToken = refreshToken
    }

    init(accessToken: String, expiresIn: TimeInterval, refreshToken: String?) {
        let expiryDate = Date().addingTimeInterval(Double(expiresIn))
        self.init(accessToken: accessToken,
                  expiryDate: expiryDate,
                  refreshToken: refreshToken)
    }
}
