//
//  KarhooUIConfigProviderSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest
@testable import KarhooSDK

final class KarhooUIConfigProviderSpec: XCTestCase {

    private var testObject = KarhooUIConfigProvider()
    
    override func setUp() {
        super.setUp()
    }

    /**
      * When: User is in DefaultOrgForKarhoo
      * Then: UIConfig model returned should not be hidden
      */
    func testConfigForDefaultKarhooUsers() {
        let request = UIConfigRequest(viewId: "additionalFeedbackButton")
        let organisation = OrganisationMock().set(id: "a1013897-132a-456c-9be2-636979095ad9").build()
        testObject.fetchConfig(uiConfigRequest: request,
                               organisation: organisation,
                               callback: { result in
                                XCTAssertFalse(result.getSuccessValue()!.hidden)
        })
    }

    /**
     * When: No config is found for a view
     * Then: Expected error should return
     */
    func testNoConfigFound() {
        let request = UIConfigRequest(viewId: "view that don't exist")
        let organisation = OrganisationMock().set(id: "a1013897-132a-456c-9be2-636979095ad9").build()
        testObject.fetchConfig(uiConfigRequest: request,
                               organisation: organisation,
                               callback: { result in
                                XCTAssertTrue(result.getErrorValue()!.equals(SDKErrorFactory.noConfigAvailableForView()))
        })
    }
}
