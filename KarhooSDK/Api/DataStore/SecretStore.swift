//
//  SecretStore.swift
//  KarhooSDK
//
//  Created by Corneliu on 05.04.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

protocol SecretStore {
    func readSecret(withKey secretKey: String) -> String?
    func saveSecret(_ secret: String, withKey secretKey: String)
    func deleteSecret(withKey secretKey: String)
}
