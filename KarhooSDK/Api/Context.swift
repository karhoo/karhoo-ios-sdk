//
//  Context.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol Context {
    func getSdkBundle() -> Bundle
    func getCurrentBundle() -> Bundle

    func isTestflightBuild() -> Bool
}

public final class CurrentContext: Context {
    private static let sdkBundle = Bundle(for: CurrentContext.self)

    private var braintreeToken: String?

    public init() {
    }

    func getSdkBundle() -> Bundle {
        return CurrentContext.sdkBundle
    }

    func getCurrentBundle() -> Bundle {
        return Bundle.main
    }

    public func isDebugBuild() -> Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

    internal func isTestflightBuild() -> Bool {
        let bundle = getSdkBundle()
        let receiptUrl = bundle.appStoreReceiptURL?.path ?? ""
        return receiptUrl.contains("sandboxReceipt")
    }
}
