//
//  UpdateUserDetailsInteractor.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol UpdaterUserDetailsInteractor: KarhooExecutable {
    func set(update: UserDetailsUpdateRequest)
}
