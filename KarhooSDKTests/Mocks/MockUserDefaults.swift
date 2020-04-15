//
//  MockUserDefaults.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class MockUserDefaults: UserDefaults {
    var synchronizeCalled = false
    override func synchronize() -> Bool {
        synchronizeCalled = true
        return super.synchronize()
    }

    var setForKeyCalled = false
    override func set(_ value: Any?, forKey defaultName: String) {
        super.set(value, forKey: defaultName)
        setForKeyCalled = true
    }
}
