//
//  MockAccessTokenProvider.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

final public class MockAccessTokenProvider: AccessTokenProvider {
    public var accessToken: AccessToken? {
        return AccessToken(token: "MockAuthToken")
    }
}
