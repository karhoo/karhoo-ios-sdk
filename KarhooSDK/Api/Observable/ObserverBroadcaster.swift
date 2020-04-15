//
//  ObserverBroadcaster.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

open class ObserverBroadcaster<ResponseType: KarhooCodableModel> {

    private var listeners: [String: WeakReferenceWrapper<Observer<ResponseType>>]  = [:]

    // MARK: - Public functions

    required public init() { }

    /**
     * @breif Adds a listener to the broadcaster
     * @param listener The listener to add. Will not be retained.
     * @return Returns the identifier of the listener added
     */
    func add(listener: Observer<ResponseType>) {
        listeners[listener.uuid] = WeakReferenceWrapper(listener)
    }

    /**
     * @breif Broadcasts closure to all listeners
     * @param closure to be broadcasted
     */
    func broadcast(result: Result<ResponseType>) {
        var zombieFound = false

        listeners.forEach {
            if let reference = $0.value.getReference() {
                reference.closure(result)
            } else {
                zombieFound = true
            }
        }

        if zombieFound {
            compact()
        }
    }

    /**
     * @breif Removes listener with key
     * @param key of the listener to be removed
     */
    func remove(listener: Observer<ResponseType>) {
        listeners.removeValue(forKey: listener.uuid)
    }

    /**
     * @breif Removes all listeners
     */
    func removeAllListeners() {
        listeners = [:]
    }

    /**
     * @breif Returns true if there are any listeners left
     */
    func hasListeners() -> Bool {
        compact()
        return listeners.count > 0
    }

    // MARK: - Private functions

    private func compact() {
        let compacted = listeners.filter {
            return $0.value.getReference() != nil
        }
        listeners = compacted
    }
}
