//
//  MockDataEncodable.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

struct MockKarhooCodableModel: KarhooCodableModel {

    let id: String

    init(id: String) {
        self.id = id
    }
}
