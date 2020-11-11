//
//  CoverageInteractor.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 10/11/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

protocol QuoteCoverageInteractor: KarhooExecutable {
    func set(coverageRequest: QuoteCoverageRequest)
}
