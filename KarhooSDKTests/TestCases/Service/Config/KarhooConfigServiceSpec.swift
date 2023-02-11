//
//  KarhooConfigServiceSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest
@testable import KarhooSDK

final class KarhooConfigServiceSpec: XCTestCase {

    private var testObject: ConfigService = KarhooConfigService()
    private var mockUIConfigInteractor = MockUIConfigInteractor()
    
    override func setUp() {
        super.setUp()

        testObject = KarhooConfigService(uiConfigInteractor: mockUIConfigInteractor)
    }

    /**
      * When: Getting config service
      * Then: Config service should be returned
      */
    func testSuccess() {
        testObject.uiConfig(uiConfigRequest: UIConfigRequest(viewId: "some")).execute(callback: { result in
            XCTAssertTrue(result.getSuccessValue()!.hidden)
        })

        mockUIConfigInteractor.triggerSuccess(result: UIConfig(hidden: true))
        XCTAssertEqual("some", mockUIConfigInteractor.uiConfigRequestSet?.viewId)
    }

    func testFail() {
        testObject.uiConfig(uiConfigRequest: UIConfigRequest(viewId: "some")).execute(callback: { result in
            XCTAssertEqual("KSDK05", result.getErrorValue()?.code)
        })

        mockUIConfigInteractor.triggerFail(error: SDKErrorFactory.noConfigAvailableForView())
        XCTAssertEqual("some", mockUIConfigInteractor.uiConfigRequestSet?.viewId)
    }
}
