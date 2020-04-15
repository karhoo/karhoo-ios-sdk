//
//  MockKarhooPollCall.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooSDK

class MockKarhooPollCall<ResponseType: KarhooCodableModel>: PollCall<ResponseType> {

    let pollableExecutorSet: KarhooPollExecutor
    override init(pollExecutor: KarhooPollExecutor) {
        pollableExecutorSet = pollExecutor
        super.init(pollExecutor: pollExecutor)
    }
}
