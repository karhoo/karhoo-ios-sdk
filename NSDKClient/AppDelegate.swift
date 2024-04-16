//
//  AppDelegate.swift
//  Client
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import UIKit
import KarhooSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Karhoo.set(configuration: SDKConfig())
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

struct SDKConfig: KarhooSDKConfiguration {
    static var auth: AuthenticationMethod?
    
    func requireSDKAuthentication(callback: @escaping () -> Void) {
        callback()
    }

    func environment() -> KarhooEnvironment {
        return .sandbox
    }

    func authenticationMethod() -> AuthenticationMethod {
        guard let auth = SDKConfig.auth else {
            let guestSettings = GuestSettings(identifier: Keys.identifier,
                                              referer: Keys.referer,
                                              organisationId: Keys.organisationId)
            return .guest(settings: guestSettings)
        }
         return auth
    }
}



