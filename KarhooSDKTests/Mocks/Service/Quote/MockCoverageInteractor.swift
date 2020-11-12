//
//  MockCoverageInteractor.swift
//  KarhooSDKTests
//
//  Created by Nurseda Balcioglu on 10/11/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockCoverageInteractor: QuoteCoverageInteractor, MockInteractor {

    var callbackSet: CallbackClosure<QuoteCoverage>?
    var cancelCalled = false

    var coverageRequestSet: QuoteCoverageRequest?
    func set(coverageRequest: QuoteCoverageRequest) {
        coverageRequestSet = coverageRequest
    }
}
