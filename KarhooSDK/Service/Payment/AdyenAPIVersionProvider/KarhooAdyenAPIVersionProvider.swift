//
//  KarhooAdyenAPIVersionProvider.swift
//  KarhooSDK
//
//  Created by Aleksander Wedrychowski on 06/04/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct KarhooAdyenAPIVersionProvider: AdyenAPIVersionProvider {
    private let userDataStore: UserDataStore
    
    init(userDataStore: UserDataStore = DefaultUserDataStore()) {
        self.userDataStore = userDataStore
    }

    func getVersion() -> String {
        let version = userDataStore.getCurrentUser()?.paymentProvider?.version
        
        switch version {
        case nil: return ""
        case "v51": return ""
        case "": return ""
        default:
            if let version = version {
                return "/\(version)"
            }
            return ""
        }
    }
}
