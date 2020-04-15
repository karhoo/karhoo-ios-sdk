//
//  PollCallFactory.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol PollCallFactory {
    func shared<T: KarhooCodableModel>(identifier: String,
                                       executable: KarhooExecutable) -> PollCall<T>
}
