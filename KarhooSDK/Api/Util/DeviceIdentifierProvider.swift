//
//  DeviceIdentifierProvider.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KeychainSwift

protocol KeychainWrapperProtocol {
    func set(_ value: String, forKey: String)
    func get(_ key: String) -> String?
}

final class KeychainWrapper: KeychainWrapperProtocol {
    private let keychain = KeychainSwift()

    func set(_ value: String, forKey key: String) {
        keychain.set(value, forKey: key)
    }

    func get(_ key: String) -> String? {
        return keychain.get(key)
    }
}

public final class DeviceIdentifierProvider {
    public static let shared = DeviceIdentifierProvider()

    private var sessionId: String?
    public var restartSessionManually = false
    private let appStateNotifier: AppStateNotifier

    private init(appStateNotifier: AppStateNotifier = AppStateNotifier.shared) {
        self.appStateNotifier = appStateNotifier
        self.appStateNotifier.register(listener: self)
    }

    deinit {
        self.appStateNotifier.remove(listener: self)
    }

    /**
     *  This UUID stays the same even after app closes
     *  or gets reinstalled
     */
    public func getPermamentID() -> String {
        let keychainKey = "karhoo_uuid"
        let keychain = KeychainWrapper()

        var uuid = keychain.get(keychainKey)
        if uuid?.isEmpty != false {
            uuid = UUID().uuidString
            keychain.set(uuid ?? "", forKey: keychainKey)
        }
        return uuid ?? ""
    }

    /**
     *  This UUID changes every time app goes into background
     */
    public func getSessionID() -> String {
        if sessionId == nil {
            restartSessionID()
        }
        return sessionId ?? ""
    }

    public func restartSessionID() {
        sessionId = UUID().uuidString
    }
}

extension DeviceIdentifierProvider: AppStateChangeDelegate {
    public func appDidEnterBackground() {
        if !restartSessionManually {
            restartSessionID()
        }
    }
}
