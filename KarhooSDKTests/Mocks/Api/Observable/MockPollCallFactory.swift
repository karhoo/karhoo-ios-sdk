//
//  MockPollCallFactory.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooSDK

class MockPollCallFactory: PollCallFactory {

    var identifierSet: String?
    var executableSet: KarhooExecutable?
    func shared<T: KarhooCodableModel>(identifier: String,
                                       executable: KarhooExecutable) -> PollCall<T> {
        self.identifierSet = identifier
        self.executableSet = executable
        return MockKarhooPollCall(pollExecutor: MockPollExecutor())
    }
}
