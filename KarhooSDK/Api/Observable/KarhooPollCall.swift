//
//  PollCall.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

open class PollCall<ResponseType: KarhooCodableModel>: Call<ResponseType> {

    private let pollExecutor: KarhooPollExecutor
    private var observablesForpollTime:[TimeInterval: Observable<ResponseType>] = [:]

    public init(pollExecutor: KarhooPollExecutor) {
        self.pollExecutor = pollExecutor
        super.init(executable: pollExecutor.executable)
    }

    open func observable(pollTime:TimeInterval = 5) -> Observable<ResponseType> {
        if observablesForPolltime[pollTime] == nil {
            observablesForPolltime[pollTime] = Observable(pollExecutor: pollExecutor,
                                                                pollTime:pollTime)
        }
        return observablesForPolltime[pollTime]!
    }
}
