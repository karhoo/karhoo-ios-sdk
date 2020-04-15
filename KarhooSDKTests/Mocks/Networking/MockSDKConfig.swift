//
//  MockKarhooSDKConfiguration.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

@testable import KarhooSDK

class MockSDKConfig: KarhooSDKConfiguration {

    let authMethod: AuthenticationMethod
    static let tokenExchangeSettings = TokenExchangeSettings(clientId: "mock-client", scope: "1234")

    init(authMethod: AuthenticationMethod = .karhooUser) {
        self.authMethod = authMethod
    }

    func environment() -> KarhooEnvironment {
        return .sandbox
    }

    func authenticationMethod() -> AuthenticationMethod {
        return authMethod
    }

}
