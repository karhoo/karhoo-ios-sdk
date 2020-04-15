//
//  Broadcaster.swift
//  YMBroadcaster
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

/**
 * @brief "Broadcasts" method invocations to it's added listeners. Does not
 * retain the listeners. Meant to be an easier-to-follow and less crash-prone
 * replacement for NSNotifications
 */
open class Broadcaster<T: AnyObject> {

    private var listeners = [WeakReferenceWrapper<T>]()

    // MARK: - Public functions

    required public init() { }

    /**
     * @breif Adds a listener to the broadcaster
     * @param listener The listener to add. Will not be retained.
     */
    open func add(listener: T) {
        let entry = WeakReferenceWrapper(listener)
        listeners.append(entry)
    }

    /**
     * @breif Removes a listener from the broadcaster
     * @param listener The listener to remove.
     */
    open func remove(listener: T) {
        for (index, element) in listeners.enumerated() {
            if element.getReference() === listener {
                listeners.remove(at: index)
            }
        }
    }

    open func broadcast(closure: (T) -> Void) {
        var zombieFound = false
        listeners.forEach { (entry: WeakReferenceWrapper<T>) in
            if let reference = entry.getReference() {
                closure(reference)
            } else {
                zombieFound = true
            }
        }

        if zombieFound {
            compact()
        }
    }

    /**
     * @breif Returns true if there are any listeners left
     */
    open func hasListeners() -> Bool {
        compact()
        return listeners.count > 0
    }

    // MARK: - Private functions

    private func compact() {
        let compacted = listeners.filter { (wrapper: WeakReferenceWrapper) -> Bool in
            return wrapper.getReference() != nil
        }
        listeners = compacted
    }
}
