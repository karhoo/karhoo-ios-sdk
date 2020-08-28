//
//  AppStateNotifier.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//
#if !os(macOS)
import UIKit
#endif

public protocol AppStateChangeDelegate: class {
    func appDidBecomeActive()
    func appWillResignActive()
    func appDidEnterBackground()
    func appWillEnterForeground()
    func appWillTerminate()
}

public extension AppStateChangeDelegate {
    func appDidBecomeActive() { }
    func appWillResignActive() { }
    func appWillTerminate() { }
    func appDidEnterBackground() { }
    func appWillEnterForeground() { }
}

public protocol AppStateNotifierProtocol {
    func register(listener: AppStateChangeDelegate)
    func remove(listener: AppStateChangeDelegate)
}

public final class AppStateNotifier: AppStateNotifierProtocol {
    private let broadcaster = Broadcaster<AnyObject>()
    public static let shared = AppStateNotifier()

    public init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillResignActive),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillTerminate),
                                               name: UIApplication.willTerminateNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appDidEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    public func register(listener: AppStateChangeDelegate) {
        broadcaster.add(listener: listener)
    }

    public func remove(listener: AppStateChangeDelegate) {
        broadcaster.remove(listener: listener)
    }

    @objc private func appDidBecomeActive() {
        broadcaster.broadcast { ($0 as? AppStateChangeDelegate)?.appDidBecomeActive() }
    }

    @objc private func appWillResignActive() {
        broadcaster.broadcast { ($0 as? AppStateChangeDelegate)?.appWillResignActive() }
    }

    @objc private func appWillTerminate() {
        broadcaster.broadcast { ($0 as? AppStateChangeDelegate)?.appWillTerminate() }
    }

    @objc private func appDidEnterBackground() {
        broadcaster.broadcast { ($0 as? AppStateChangeDelegate)?.appDidEnterBackground() }
    }

    @objc private func appWillEnterForeground() {
        broadcaster.broadcast { ($0 as? AppStateChangeDelegate)?.appWillEnterForeground() }
    }
}
