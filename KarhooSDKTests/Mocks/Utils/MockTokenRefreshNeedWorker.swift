//
//  MockTokenRefreshNeedWorker.swift
//  KarhooSDKTests
//
//  Created by Aleksander Wedrychowski on 05/10/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
@testable import KarhooSDK

class MockTokenRefreshNeedWorker: TokenRefreshNeedWorker {
    var bufferSaved = false
    func saveRefreshBuffer(token: KarhooSDK.AuthToken) {
        bufferSaved = true
    }
    
    var tokenNeedsRefreshingToReturn = false
    func tokenNeedsRefreshing(credentials: KarhooSDK.Credentials) -> Bool {
        tokenNeedsRefreshingToReturn
    }
    
    var refreshTokenNeedsRefreshingToReturn = false
    func refreshTokenNeedsRefreshing(credentials: KarhooSDK.Credentials?) -> Bool {
        refreshTokenNeedsRefreshingToReturn
    }
}
