//
//  MockCancellationFeeInteractor.swift
//  KarhooSDKTests
//
//  Created by Nurseda Balcioglu on 03/12/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
@testable import KarhooSDK

final class MockCancellationFeeInteractor: CancellationFeeInteractor, MockInteractor {

    var callbackSet: CallbackClosure<KarhooVoid>?
    var cancelCalled = false
    
    var identifierSet: String?
    func set(identifier: String){
        identifierSet = identifier
    }
}
