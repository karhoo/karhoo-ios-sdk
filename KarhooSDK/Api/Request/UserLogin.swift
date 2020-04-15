//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct UserLogin: KarhooCodableModel {

    public let username: String
    public let password: String

    public init(username: String = "",
                password: String = "") {
        self.username = username
        self.password = password
    }
}
