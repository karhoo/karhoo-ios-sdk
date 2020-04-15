//
//  MockAppStateNotifier.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

class MockAppStateNotifier: AppStateNotifierProtocol {
    private(set) var listener: AppStateChangeDelegate?

    func register(listener: AppStateChangeDelegate) {
        self.listener = listener
    }

    func remove(listener: AppStateChangeDelegate) {
        self.listener = nil
    }

    func signalAppDidBecomeActive() {
        listener?.appDidBecomeActive()
    }

    func signalAppWillResignActive() {
        listener?.appWillResignActive()
    }
}
