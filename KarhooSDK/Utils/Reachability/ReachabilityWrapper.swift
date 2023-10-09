//
//  ReachabilityWrapper.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public protocol ReachabilityProvider {
    func add(listener: ReachabilityListener)
    func remove(listener: ReachabilityListener)
    func isReachable() -> Bool
    var currentReachabilityStatus: Reachability.Connection.Type { get }
}

public extension ReachabilityProvider {
   var currentReachabilityStatus: Reachability.Connection.Type {
        return Reachability.Connection.self
    }
}

public protocol ReachabilityListener: AnyObject {
    func reachabilityChanged(isReachable: Bool)
}

protocol ReachabilityProtocol {
    func startNotifier() throws
    func stopNotifier()
    var connectionStatus: Reachability.Connection { get }
    var whenReachable: Reachability.NetworkReachable? { get set }
    var whenUnreachable: Reachability.NetworkUnreachable? { get set }
}

extension Reachability: ReachabilityProtocol {
    var connectionStatus: Reachability.Connection {
        return self.connection
    }
}

public final class ReachabilityWrapper: ReachabilityProvider {

    public static let shared = ReachabilityWrapper(reachability: try! Reachability())

    private(set) var reachability: ReachabilityProtocol
    private let broadcaster: Broadcaster<AnyObject>
    private var lastStatus: Reachability.Connection

    public var currentReachabilityStatus: Reachability.Connection {
        return reachability.connectionStatus
    }

    init(reachability: ReachabilityProtocol,
         broadcaster: Broadcaster<AnyObject> = Broadcaster<AnyObject>()) {
        self.reachability = reachability
        lastStatus = reachability.connectionStatus
        self.broadcaster = broadcaster

        self.reachability.whenReachable = { [weak self] (_) in
            self?.reactToPotentialNetworkStatusChange()
        }

        self.reachability.whenUnreachable = { [weak self] (_) in
            self?.reactToPotentialNetworkStatusChange()
        }
    }

    public func add(listener: ReachabilityListener) {
        if !broadcaster.hasListeners() {
            try? reachability.startNotifier()
        }

        broadcaster.add(listener: listener)
        listener.reachabilityChanged(isReachable: reachability.connectionStatus != .unavailable)
    }

    public func remove(listener: ReachabilityListener) {
        broadcaster.remove(listener: listener)

        if !broadcaster.hasListeners() {
            reachability.stopNotifier()
        }
    }

    public func isReachable() -> Bool {
        return reachability.connectionStatus != .unavailable
    }

    private func reactToPotentialNetworkStatusChange() {
        let currentStatus = reachability.connectionStatus

        let wasReachable = lastStatus != .unavailable
        let isReachable = currentStatus != .unavailable
        guard wasReachable != isReachable else {
            return
        }

        lastStatus = currentStatus
        broadcast(isReachable: currentStatus != .unavailable)
    }

    private func broadcast(isReachable: Bool) {
        broadcaster.broadcast { (listener: AnyObject) in
            guard let listener = listener as? ReachabilityListener else {
                return
            }
            listener.reachabilityChanged(isReachable: isReachable)
        }
    }
}
