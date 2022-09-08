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

    ///
    ///  Bool value inside success results tells if SDK had to make a backend call to refresh token
    ///
    func refreshToken(completion: @escaping (Result<Bool>) -> Void)
}
