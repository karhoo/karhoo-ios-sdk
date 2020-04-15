//
//  ContextSpec.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest

@testable import KarhooSDK

class ContextSpec: XCTestCase {

    private var testObject: CurrentContext!

    override func setUp() {
        super.setUp()

        testObject = CurrentContext()
    }

    /**
     *  When:   Getting the sdk bundle
     *  Then:   The sdk bundle should be fetched
     */
    func testSDKBundle() {
        let bundle = testObject.getSdkBundle()
        XCTAssert(bundle.bundleIdentifier?.hasSuffix("KarhooSDK") == true)
    }

    /**
     *  When:   Getting the current bundle
     *  Then:   The main bundle should be fetched
     */
    func testGetMainBundle() {
        let bundle = testObject.getCurrentBundle()
        XCTAssert(bundle == Bundle.main)
    }
}
