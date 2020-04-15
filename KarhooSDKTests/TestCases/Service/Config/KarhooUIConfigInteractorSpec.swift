//
//  KarhooUIConfigInteractorSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest
@testable import KarhooSDK

final class KarhooUIConfigInteractorSpec: XCTestCase {

    private var testObject: UIConfigInteractor = KarhooUIConfigInteractor()
    private var mockUIConfigProvider = MockUIConfigProvider()
    private var mockUserDataStore = MockUserDataStore()
    private let mockUser = UserInfoMock().set(userId: "some").set(organisation: [Organisation(id: "orgId",
                                                                                  name: "orgName",
                                                                                  roles: [])])
    override func setUp() {
        super.setUp()

        testObject = KarhooUIConfigInteractor(userDataStore: mockUserDataStore,
                                              uiConfigProvider: mockUIConfigProvider)
    }

    /**
      * When: no config request is set
      * Then: Callback should be unexpected error
      * And: Provider should not be called
      */
    func testConfigRequestNotSet() {
        testObject.execute(callback: { (result: Result<UIConfig>) in
            XCTAssert(result.errorValue()?.code == "KSDK01")
        })

        XCTAssertFalse(mockUIConfigProvider.fetchConfigCalled)
    }

    /**
     * When: no user in the data store
     * Then: Callback should be user error
     * And: Provider should not be called
     */
    func testNoUserAvailable() {
        mockUserDataStore.userToReturn = nil
        testObject.set(uiConfigRequest: UIConfigRequest(viewId: "some"))
        testObject.execute(callback: { (result: Result<UIConfig>) in
            XCTAssert(result.errorValue()?.code == "KSDK02")
        })

        XCTAssertFalse(mockUIConfigProvider.fetchConfigCalled)
    }

    /**
     * When: Provider returns config
     * Then: Callback should be success
     */
    func testProviderSucceeds() {
        testObject.set(uiConfigRequest: UIConfigRequest(viewId: "someViewId"))
        mockUserDataStore.userToReturn = mockUser.build()

        testObject.execute(callback: { (result: Result<UIConfig>) in
            XCTAssertTrue(result.successValue()!.hidden)
        })

        mockUIConfigProvider.triggerConfigCallbackResult(.success(result: UIConfig(hidden: true)))
        XCTAssertEqual(mockUser.build().organisations[0].name, mockUIConfigProvider.organisationSet?.name)
        XCTAssertEqual("someViewId", mockUIConfigProvider.uiconfigRequestSet?.viewId)
    }

    /**
     * When: no config request is set
     * Then: Callback should be unexpected error
     */
    func testProviderFails() {
        testObject.set(uiConfigRequest: UIConfigRequest(viewId: "someViewId"))
        mockUserDataStore.userToReturn = mockUser.build()

        testObject.execute(callback: { (result: Result<UIConfig>) in
            XCTAssertEqual("KSDK05", result.errorValue()?.code)
        })

        mockUIConfigProvider.triggerConfigCallbackResult(.failure(error: SDKErrorFactory.noConfigAvailableForView()))

    }
}
