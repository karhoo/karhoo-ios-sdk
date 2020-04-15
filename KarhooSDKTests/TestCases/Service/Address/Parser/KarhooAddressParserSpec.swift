//
//  KarhooAddressParserSpec.swift
//  KarhooSDK
//
//  Created by Yaser on 2017-06-06.
//  Copyright © 2017 Flit Technologies Ltd. All rights reserved.
//

import XCTest
import CoreLocation

@testable import KarhooSDK

//swiftlint:disable force_try

class KarhooAddressParserSpec: XCTestCase {

    /**
     *  When:   Parsing an address to a dictionary
     *  Then:   The corresponding dictionary should be produced
     */
    func testToDictionary() {
        let address = ObjectTestFactory.getRandomAddress()

        let dictionary = KarhooAddressParser().from(address: address)

        XCTAssert(compare(dictionary: dictionary, address: address))
    }

    /**
     *  When:   Parsing a valid dictionary to an Address
     *  Then:   The corresponding address should be produced
     */
    func testToAddress() {
        let dictionary = createValidDictionary()

        let address = try! KarhooAddressParser().from(dictionary: dictionary)

        XCTAssert(compare(dictionary: dictionary, address: address))
    }

    /**
     *  When:   Parsing a dictionary with optional values missing to an Address
     *  Then:   The corresponding address should be produced
     */
    func testToAddressConversionWithMissingOptionals() {
        let dictionary = createValidDictionary(rawData: nil)

        let address = try! KarhooAddressParser().from(dictionary: dictionary)

        XCTAssert(compare(dictionary: dictionary, address: address))
    }

    /**
     *  When:   Parsing an dictionary missing mandatory address fields
     *  Then:   An error should be thrown
     */
    func testInvalidToAddress() {
        let keysToRemove = [AddressParserKeys.placeId.rawValue,
                            AddressParserKeys.lineOne.rawValue,
                            AddressParserKeys.latitude.rawValue,
                            AddressParserKeys.longitude.rawValue]

        let testObject = KarhooAddressParser()

        keysToRemove.forEach { (key: String) in
            var dictionary = createValidDictionary()
            dictionary.removeValue(forKey: key)

            var errorThrown: ParserError?
            do {
                _ = try testObject.from(dictionary: dictionary)
            } catch let error {
                errorThrown = error as? ParserError
            }

            XCTAssert(errorThrown! == .infoMissing(key))
        }
    }

    /**
     *  When:   Parsing a dictionary containing the wrong types
     *  Then:   An error should be thrown
     */
    func testInvalidTypedToAddress() {
        let keysToAlter = [AddressParserKeys.placeId.rawValue,
                           AddressParserKeys.lineOne.rawValue,
                           AddressParserKeys.latitude.rawValue,
                           AddressParserKeys.longitude.rawValue]

        let testObject = KarhooAddressParser()

        keysToAlter.forEach { (key: String) in
            var dictionary = createValidDictionary()
            dictionary[key] = NSObject()

            var errorThrown: ParserError?
            do {
                _ = try testObject.from(dictionary: dictionary)
            } catch let error {
                errorThrown = error as? ParserError
            }

            XCTAssert(errorThrown! == .infoMissing(key))
        }
    }

    private func compare(dictionary: [String: Any?], address: Address) -> Bool {
        var isSame = true

        isSame = isSame && dictionary[AddressParserKeys.placeId.rawValue] as? String == address.placeId
        isSame = isSame && dictionary[AddressParserKeys.displayAddress.rawValue] as? String == address.displayAddress
        isSame = isSame && dictionary[AddressParserKeys.lineOne.rawValue] as? String == address.lineOne

        let lat = dictionary[AddressParserKeys.latitude.rawValue] as? CLLocationDegrees
        isSame = isSame && lat  == address.location.coordinate.latitude

        let lon = dictionary[AddressParserKeys.longitude.rawValue] as? CLLocationDegrees
        isSame = isSame && lon == address.location.coordinate.longitude

        return isSame
    }

    private func createValidDictionary(rawData: Data? = Data()) -> [String: Any] {
        var dictionary = [String: Any]()

        dictionary[AddressParserKeys.placeId.rawValue] = TestUtil.getRandomString()
        dictionary[AddressParserKeys.displayAddress.rawValue] = TestUtil.getRandomString()
        dictionary[AddressParserKeys.lineOne.rawValue] = TestUtil.getRandomString()
        dictionary[AddressParserKeys.lineTwo.rawValue] = TestUtil.getRandomString()

        let coordinate = TestUtil.getRandomLocation().coordinate
        dictionary[AddressParserKeys.latitude.rawValue] = coordinate.latitude
        dictionary[AddressParserKeys.longitude.rawValue] = coordinate.longitude
        dictionary[AddressParserKeys.rawData.rawValue] = rawData

        return dictionary
    }
}

//swiftlint:enable force_try
