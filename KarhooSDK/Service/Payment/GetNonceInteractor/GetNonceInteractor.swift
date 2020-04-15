//
//  GetNonceInteractor.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol GetNonceInteractor: KarhooExecutable {
    func set(nonceRequestPayload: NonceRequestPayload)
}
