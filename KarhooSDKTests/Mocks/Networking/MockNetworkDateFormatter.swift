//
//  MockNetworkDateFormatter.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class MockNetworkDateFormatter: NetworkDateFormatter {
    var stringToReturn: String = TestUtil.getRandomString()
    var dateToConvert: Date?
    func toString(from date: Date) -> String {
        dateToConvert = date
        return stringToReturn
    }
}
