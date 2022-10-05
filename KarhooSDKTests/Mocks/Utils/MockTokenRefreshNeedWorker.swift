//
//  MockTokenRefreshNeedWorker.swift
//  KarhooSDKTests
//
//  Created by Aleksander Wedrychowski on 05/10/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
@testable import KarhooSDK

class MockTokenValidityWorker: TokenValidityWorker {
    
    var timeToRequiredRefreshToReturn = TimeInterval(0)
    func timeToRequiredRefresh() -> TimeInterval {
        timeToRequiredRefreshToReturn
    }

    var bufferSaved = false
    func saveRefreshBuffer(token: KarhooSDK.AuthToken) {
        bufferSaved = true
    }
    
    var tokenNeedsRefreshingToReturn = false
    func tokenNeedsRefreshing() -> Bool {
        tokenNeedsRefreshingToReturn
    }
    
    var refreshTokenNeedsRefreshingToReturn = false
    func refreshTokenNeedsRefreshing() -> Bool {
        refreshTokenNeedsRefreshingToReturn
    }
}
