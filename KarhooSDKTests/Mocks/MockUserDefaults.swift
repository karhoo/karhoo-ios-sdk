//
//  MockUserDefaults.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class MockUserDefaults: UserDefaults {
    var valuesForKeys = [String: Any?]()

    var setForKeyCalled = false
    override func set(_ value: Any?, forKey defaultName: String) {
        setForKeyCalled = true
        valuesForKeys[defaultName] = value
    }

    override func value(forKey key: String) -> Any? {
        return valuesForKeys[key] ?? nil
    }
}
