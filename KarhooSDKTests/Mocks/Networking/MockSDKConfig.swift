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
    static var authenticationMethod: AuthenticationMethod = .tokenExchange(settings: tokenExchangeSettings)

    func environment() -> KarhooEnvironment {
        return .sandbox
    }

    func authenticationMethod() -> AuthenticationMethod {
        return Self.authenticationMethod
    }
    
    static var requireSDKAuthenticationCompletion: () -> Void = {}
    func requireSDKAuthentication(callback: @escaping () -> Void) {
        MockSDKConfig.requireSDKAuthenticationCompletion()
        callback()
    }
}
