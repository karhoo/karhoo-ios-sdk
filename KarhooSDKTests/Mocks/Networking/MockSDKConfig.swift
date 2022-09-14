//
//  MockKarhooSDKConfiguration.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

@testable import KarhooSDK

class MockSDKConfig: KarhooSDKConfiguration {

    static var tokenExchangeSettings = TokenExchangeSettings(clientId: "mock-client", scope: "1234")
    static var guestSettings = GuestSettings(identifier: "mock-identifier",
                                             referer: "mock-referer", organisationId: "mock-organisationId")
    static var authenticationMethod: AuthenticationMethod = .karhooUser

    func environment() -> KarhooEnvironment {
        return .sandbox
    }

    func authenticationMethod() -> AuthenticationMethod {
        return Self.authenticationMethod
    }
    
    static var requestNewAuthenticationCredentialsCompletion: () -> Void = {}
    func requestNewAuthenticationCredentials(callback: @escaping () -> Void) {
        MockSDKConfig.requestNewAuthenticationCredentialsCompletion()
    }
}
