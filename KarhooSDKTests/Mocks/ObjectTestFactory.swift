//
//  ObjectTestFactory.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import CoreLocation

@testable import KarhooSDK

class ObjectTestFactory {

    class func getRandomCredentials(
        expiryDate: Date? = TestUtil.getRandomDate(),
        withRefreshToken: Bool = true,
        refreshTokenExpiryDate: Date? = TestUtil.getRandomDate()
    
    ) -> Credentials {
        return Credentials(
            accessToken: TestUtil.getRandomString(),
            expiryDate: expiryDate,
            refreshToken: (withRefreshToken ? TestUtil.getRandomString() : nil),
            refreshTokenExpiryDate: refreshTokenExpiryDate
        )
    }
}
