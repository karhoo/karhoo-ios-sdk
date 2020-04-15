//
//  MockObserverBroadcaster.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockObserverBroadcaster<ResponseType: KarhooCodableModel>: ObserverBroadcaster<ResponseType> {

    var removeAllListenersCalled = false
    override func removeAllListeners() {
        super.removeAllListeners()
        removeAllListenersCalled = true
    }

    var addListenerCalled = false
    override func add(listener: Observer<ResponseType>) {
        addListenerCalled = true
        super.add(listener: listener)
    }

    var removedListener: Observer<ResponseType>?
    override func remove(listener: Observer<ResponseType>) {
        super.remove(listener: listener)
        removedListener = listener
    }

    private(set) var broadcastedResult: Result<ResponseType>?
    override func broadcast(result: Result<ResponseType>) {
        super.broadcast(result: result)
        broadcastedResult = result
    }
}
