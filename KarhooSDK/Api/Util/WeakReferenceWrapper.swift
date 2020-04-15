//
//  WeakReferenceWrapper.swift
//  YMBroadcaster
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

/**
 * @brief Class which wraps a pointer weakly to prevent retention
 */
class WeakReferenceWrapper<T: AnyObject> {

    private weak var weakReference: T?

    // MARK: - Init functions

    required init(_ reference: T) {
        self.weakReference = reference
    }

    // MARK: - Public functions

    func getReference() -> T? {
        return self.weakReference
    }
}
