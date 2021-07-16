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
         authCredentialsInteractor: AuthLoginWithCredentialsInteractor = KarhooAuthLoginWithCredentialsInteractor(),
         revokeInteractor: KarhooExecutable = KarhoooAuthRevokeInteractor()) {
        self.revokeInteractor = revokeInteractor
        self.authCredentialsInteractor = authCredentialsInteractor
        self.authInteractor = authInteractor
    }

    func login(token: String) -> Call<UserInfo> {
        authInteractor.set(token: token)
        return Call(executable: authInteractor)
    }
    
    func login(authToken: AuthToken?) -> Call<UserInfo> {
        authCredentialsInteractor.set(auth: authToken)
        return Call(executable: authCredentialsInteractor)
    }

     func revoke() -> Call<KarhooVoid> {
        return Call(executable: revokeInteractor)
    }
}
