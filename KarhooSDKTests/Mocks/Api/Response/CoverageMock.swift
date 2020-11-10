//
//  CoverageMock.swift
//  KarhooSDKTests
//
//  Created by Nurseda Balcioglu on 10/11/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
@testable import KarhooSDK

final class CoverageMock {

    private var coverage: Coverage

    init() {
        self.coverage = Coverage()
    }

    func build() -> Coverage {
        return coverage
    }

    func set(coverage: Bool) -> CoverageMock {
        create(coverage: coverage)
        return self
    }

    private func create(coverage: Bool = false) {
        
        self.coverage = Coverage(coverage: coverage)
        
    }
    

}
