//
//  MockSecretStore.swift
//  KarhooSDKTests
//
//  Created by Corneliu on 05.04.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
@testable import KarhooSDK

class MockSecretStore: SecretStore {

    var secretsForKeysToRead: [String: String?] = [CredentialsStoreKeys.accessToken.rawValue: "some access token",
                                                   CredentialsStoreKeys.refreshToken.rawValue: "some refresh token",
                                                   CredentialsStoreKeys.expiryDate.rawValue: String(Date(timeIntervalSinceNow: 5*60).timeIntervalSince1970)]

    var keysReadValueFor = [String]()
    var keysToDeleteValuesFor = [String]()
    var secretsForKeysToSave = [String: String]()

    func readSecret(withKey secretKey: String) -> String? {
        keysReadValueFor.append(secretKey)
        return secretsForKeysToRead[secretKey] ?? nil
    }

    func deleteSecret(withKey secretKey: String) {
        keysToDeleteValuesFor.append(secretKey)
    }

    func saveSecret(_ secret: String, withKey secretKey: String) {
        secretsForKeysToSave[secretKey] = secret
    }
}
