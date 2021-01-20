//
//  CancellationFeeInteractor.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 02/12/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

protocol CancellationFeeInteractor: KarhooExecutable {
    func set(identifier: String)
}
