//
//  CoverageMock.swift
//  KarhooSDKTests
//
//  Created by Nurseda Balcioglu on 10/11/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
@testable import KarhooSDK

final class QuoteCoverageMock {
    
    private var coverage: QuoteCoverage
    
    init() {
        self.coverage = QuoteCoverage(coverage: false)
    }
    
    func set(coverage: Bool) -> QuoteCoverageMock {
        create(coverage: coverage)
        return self
    }
    
    private func create(coverage: Bool = false) {
        self.coverage = QuoteCoverage(coverage: coverage)
    }
    
    func build() -> QuoteCoverage {
        return coverage
    }
}
