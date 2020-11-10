//
//  MockCoverageInteractor.swift
//  KarhooSDKTests
//
//  Created by Nurseda Balcioglu on 10/11/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockCoverageInteractor: CoverageInteractor, MockInteractor {

    var callbackSet: CallbackClosure<Coverage>?
    var cancelCalled = false

    var coverageRequestSet: CoverageRequest?
    func set(coverageRequest: CoverageRequest) {
        coverageRequestSet = coverageRequest
    }
}
