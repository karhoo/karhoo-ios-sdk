//
//  KarhooPollCallFactory.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooPollCallFactory: PollCallFactory {
    private var sharedCalls: [String: AnyObject] = [:]

    func shared<T: KarhooCodableModel>(identifier: String,
                                       executable: KarhooExecutable) -> PollCall<T> {
        if let call = sharedCalls[identifier] as? PollCall<T> {
            return call
        }

        let pollExecutor = PollExecutor(executable: executable)
        let call = PollCall<T>(pollExecutor: pollExecutor)
        sharedCalls[identifier] = call
        return call
    }
}
