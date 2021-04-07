//
//  KeychainSecretStore.swift
//  KarhooSDK
//
//  Created by Corneliu on 05.04.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KeychainSwift

struct KeychainSecretStore: SecretStore {

    // MARK: Properties
    private let keychain = KeychainSwift()

    // MARK: Keychain access

    func readSecret(withKey secretKey: String) -> String? {
        return keychain.get(secretKey)
    }

    func saveSecret(_ secret: String, withKey secretKey: String) {
        keychain.set(secret, forKey: secretKey)
    }

    func deleteSecret(withKey secretKey: String) {
        keychain.delete(secretKey)
    }
}
