//
//  WeakReferenceWrapperSpec.swift
//  YMBroadcaster
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest

@testable import KarhooSDK

class WeakReferenceWrapperSpec: XCTestCase {

    /**
     *  When    Creating a wrapper
     *  Then    The stored reference should be conained in the wrapper
     */

    func testReferenceAssignment() {

        let testObject = TestObject()
        let weakReferenceWrapper = WeakReferenceWrapper<TestObject>(testObject)
        let storedReference = weakReferenceWrapper.getReference()

        XCTAssertTrue(storedReference === testObject)
    }

    /**
     *  When    An object that has been wrapped removed from all other scopes
     *  Then    The object should be deallocated
     *          And the wrapper should no longer contain a reference to it
     */
    func testReferenceDeallocated() {

        var testObject: TestObject? = TestObject()

        let deinitExpectation = expectation(description: "Deallocation expectation")
        testObject?.deinitCallback = {
            deinitExpectation.fulfill()
        }

        let weakReferenceWrapper = WeakReferenceWrapper<TestObject>(testObject!)
        testObject = nil

        XCTAssertNotNil(weakReferenceWrapper)
        let storedReference = weakReferenceWrapper.getReference()
        XCTAssertNil(storedReference)

        waitForExpectations(timeout: 10, handler: nil)
    }
}

private class TestObject {

    var deinitCallback: (() -> Void)?

    deinit {
        deinitCallback?()
    }
}
