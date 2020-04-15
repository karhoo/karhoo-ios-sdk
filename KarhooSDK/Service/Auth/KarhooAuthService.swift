//
//  KarhooSSOAuthService.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooAuthService: AuthService {

    private let authInteractor: AuthLoginInteractor
    private let revokeInteractor: KarhooExecutable
    
    init(authInteractor: AuthLoginInteractor = KarhooAuthLoginInteractor(),
         revokeInteractor: KarhooExecutable = KarhoooAuthRevokeInteractor()) {
        self.revokeInteractor = revokeInteractor
        self.authInteractor = authInteractor
    }

    func login(token: String) -> Call<UserInfo> {
        authInteractor.set(token: token)
        return Call(executable: authInteractor)
    }

     func revoke() -> Call<KarhooVoid> {
        return Call(executable: revokeInteractor)
    }
}
