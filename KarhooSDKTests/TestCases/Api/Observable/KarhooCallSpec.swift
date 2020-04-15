//
//  KarhooCallSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

final class KarhooCallSpec: XCTestCase {

    private var testObject: Call<MockKarhooCodableModel>!
    private var mockExecutable = MockExecutable<MockKarhooCodableModel>()

    override func setUp() {
        super.setUp()
        testObject = Call<MockKarhooCodableModel>(executable: mockExecutable)
    }

    /**
      * When: Calling execute on a KarhooCall
      * Then: KarhooCall should execute its executable
      */
    func testKarhooCallExecutesExecutable() {
        testObject.execute(callback: { _ in})
        XCTAssertTrue(mockExecutable.didExecute)
    }
}
