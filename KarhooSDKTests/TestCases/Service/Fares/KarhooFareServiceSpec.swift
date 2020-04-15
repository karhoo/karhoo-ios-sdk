//
//  KarhooFareServiceSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest

@testable import KarhooSDK

final class KarhooFareServiceSpec: XCTestCase {
    
    private var mockFareInteractor: MockFareInteractor!
    private var testObject: FareService!
    
    override func setUp() {
        super.setUp()
        
        mockFareInteractor = MockFareInteractor()
        mockFareInteractor.cancelCalled = true
        testObject = KarhooFareService(fareInteractor: mockFareInteractor)
    }
    
    /**
     Given: Getting a Fare
     Then: Fare should be returned
     */
    func testFare() {
        let call = testObject.fareDetails(tripId: "some")
        XCTAssertNotNil(call)
    }
}
