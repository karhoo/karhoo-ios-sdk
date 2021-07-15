//
//  KarhooSSOAuthService.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooAuthService: AuthService {

    private let authInteractor: AuthLoginInteractor
    private let authCredentialsInteractor: AuthLoginWithCredentialsInteractor
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
    
    func login(credentials: Credentials?) -> Call<UserInfo> {
        authCredentialsInteractor.set(credentials: credentials)
        return Call(executable: authCredentialsInteractor)
    }

     func revoke() -> Call<KarhooVoid> {
        return Call(executable: revokeInteractor)
    }
}
