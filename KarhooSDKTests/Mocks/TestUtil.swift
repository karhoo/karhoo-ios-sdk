//
//  TestUtil.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import CoreLocation

@testable import KarhooSDK

class TestUtil {

    class func getRandomError() -> MockError {
        return MockError(code: TestUtil.getRandomString(),
                          message: TestUtil.getRandomString(),
                          userMessage: TestUtil.getRandomString())
    }

    class func getUnauthenticatedError() -> HTTPError {
        return HTTPError(statusCode: 401, errorType: .userAuthenticationRequired)
    }

    class func getRandomLocation() -> CLLocation {
        return CLLocation(latitude: getRandomCoordinateComponent(),
                          longitude: getRandomCoordinateComponent())
    }

    class func getRandomCoordinateComponent() -> CLLocationDegrees {
        return CLLocationDegrees(arc4random_uniform(1000)/10)
    }

    class func getRandomString(length: Int = 32) -> String {
        let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let noOfLetters = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            let rand = arc4random_uniform(noOfLetters)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }

    class func getRandomInt(lessThan: UInt32 = UInt32(INT_MAX)) -> Int {
        return Int(arc4random_uniform(UInt32(lessThan)))
    }

    class func getRandomDate(laterThan date: Date = Date()) -> Date {
        let timeInterval = date.timeIntervalSince1970 + TimeInterval(arc4random_uniform(10000000))
        return Date(timeIntervalSince1970: timeInterval)
    }

    class func datesEqual(_ first: Date?, _ second: Date?, precision: TimeInterval = 0.1) -> Bool {
        guard let first = first, let second = second else {
            return false
        }

        let timeDifference = abs(first.timeIntervalSince1970 - second.timeIntervalSince1970)
        let epsilon = precision
        return (timeDifference < epsilon)
    }
}
