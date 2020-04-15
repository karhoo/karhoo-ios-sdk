//
//  SSOAuthLoginInteractor.swift
//  KarhooSDK
//
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public protocol AuthLoginInteractor: KarhooExecutable {
    func set(token: String)
}
