//
//  CredentialParser.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol CredentialsParser {
    func from(dictionary: [String: Any]?) -> Credentials?
    func from(credentials: Credentials?) -> [String: Any]?
}

final class DefaultCredentialsParser: CredentialsParser {

    func from(dictionary: [String: Any]?) -> Credentials? {

        guard let dictionary = dictionary else {
            return nil
        }

        return createCredentials(dictionary)
    }

    private func createCredentials(_ dictionary: [String: Any]) -> Credentials? {
        guard let accessToken = dictionary[CredentialsStoreKeys.accessToken.rawValue] as? String else {
            return nil
        }

        let expiryDate = dictionary[CredentialsStoreKeys.expiryDate.rawValue] as? Date
        let refreshToken = dictionary[CredentialsStoreKeys.refreshToken.rawValue] as? String

        return Credentials(accessToken: accessToken,
                           expiryDate: expiryDate,
                           refreshToken: refreshToken)
    }

    func from(credentials: Credentials?) -> [String: Any]? {
        guard let credentials = credentials else {
            return nil
        }

        var dictionary: [String: Any] = [:]

        dictionary[CredentialsStoreKeys.accessToken.rawValue] = credentials.accessToken
        dictionary[CredentialsStoreKeys.expiryDate.rawValue] = credentials.expiryDate
        dictionary[CredentialsStoreKeys.refreshToken.rawValue] = credentials.refreshToken
        return dictionary
    }
}

enum CredentialsStoreKeys: String {
    case accessToken
    case expiryDate
    case refreshToken
}
