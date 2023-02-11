//
//  KarhooObservable.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

open class Observable<ResponseType: KarhooCodableModel> {

    private let pollExecutor: KarhooPollExecutor
    private let broadcaster: ObserverBroadcaster<ResponseType>
    private let pollTime:TimeInterval

    public init(pollExecutor: KarhooPollExecutor,
                pollTime:TimeInterval,
                broadcaster: ObserverBroadcaster<ResponseType> = ObserverBroadcaster<ResponseType>()) {
        self.pollExecutor = pollExecutor
        self.pollTime = pollTime
        self.broadcaster = broadcaster
    }

    open func subscribe(observer: Observer<ResponseType>) {
        let shouldStartPolling = broadcaster.hasListeners() == false
        broadcaster.add(listener: observer)

        if shouldStartPolling {
            pollExecutor.startPolling(pollTime:pollTime) { result in
                // Intentionally strong reference to self, KarhooDisposable is taking care of disposal
                self.broadcaster.broadcast(result: result)
            }
        }
    }

    open func unsubscribe(observer: Observer<ResponseType>) {
        broadcaster.remove(listener: observer)
        if broadcaster.hasListeners() == false {
            pollExecutor.stopPolling()
        }
    }
}
