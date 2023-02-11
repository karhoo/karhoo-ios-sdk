//
//  ResultSpec.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest

@testable import KarhooSDK

class ResultSpec: XCTestCase {

    /**
     *  Given:  A successfull result
     *  When:   Checking if successfull
     *  Then:   It should return true
     */
    func testIsSuccess() {
        let result: Result<Int> = .success(result: 3)

        XCTAssertTrue(result.isSuccess())
    }

    /**
     *  Given:  A successfull result
     *  When:   Getting the success value
     *  Then:   It should return the associated value
     */
    func testSuccessValue() {
        let result: Result<Int> = .success(result: 5)

        XCTAssert(result.getSuccessValue() == 5)
    }

    /**
     *  Given:  A successfull result
     *  When:   Getting the error value
     *  Then:   It should return nil
     */
    func testSuccessFailureValue() {
        let result: Result<Int> = .success(result: 5)

        XCTAssertNil(result.getErrorValue())
    }

    /**
     *  Given:  A failure result
     *  When:   Checking if successfull
     *  Then:   It should return false
     */
    func testIsSuccessWhenFailure() {
        let result: Result<Int> = .failure(error: nil)

        XCTAssertFalse(result.isSuccess())
    }

    /**
     *  Given:  A failure result
     *    And:  Error is set
     *  When:   Getting the error
     *  Then:   It should return the error
     */
    func testValueWhenFailure() {
        let expectedError = TestUtil.getRandomError()
        let result: Result<String> = .failure(error: expectedError)

        XCTAssertNotNil(result.getErrorValue())
        XCTAssert(expectedError.equals(result.getErrorValue()!))
    }

    /**
     *  Given:  A failure result
     *    And:  Error is not set
     *  When:   Getting the error
     *  Then:   It should return nil
     */
    func testNilError() {
        let result: Result<String> = .failure(error: nil)

        XCTAssertNil(result.getErrorValue())
    }

    /**
     *  Given:  A failure result
     *  When:   Getting the associated success value
     *  Then:   It should return nil
     */
    func testSuccessValueWhenFailure() {
        let error = TestUtil.getRandomError()
        let result: Result<String> = .failure(error: error)

        XCTAssertNil(result.getSuccessValue())
    }
}
