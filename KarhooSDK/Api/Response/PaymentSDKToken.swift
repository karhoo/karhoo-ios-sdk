//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct PaymentSDKToken: KarhooCodableModel {

    public let token: String
    public init(token: String = "") {
        self.token = token
    }
}
