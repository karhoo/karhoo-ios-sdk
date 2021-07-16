//
//  AuthLoginWithCredentialsInteractor.swift
//  KarhooSDK
//
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public protocol AuthLoginWithCredentialsInteractor: KarhooExecutable {
    func set(auth: AuthToken?)
}
