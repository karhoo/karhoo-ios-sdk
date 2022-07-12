//
//  RefreshTokenInteractor.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol RefreshTokenInteractor {
    func tokenNeedsRefreshing() -> Bool

    func refreshToken(completion: @escaping (Result<Bool>) -> Void)
    func refreshTokenWithCorrelationId(completion: @escaping (ResultWithCorrelationId<Bool>) -> Void)
}
