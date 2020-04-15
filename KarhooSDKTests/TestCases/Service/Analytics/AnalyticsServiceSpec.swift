//
//  AnalyticsServiceSpec.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest

@testable import KarhooSDK

final class AnalyticsServiceSpec: XCTestCase {

    private var mockContext: MockContext!
    private var mockUserDataStore: MockUserDataStore!
    private var testObject: KarhooAnalyticsService!
    private var mockProvider: MockAnalyticsProvider!

    override func setUp() {
        super.setUp()

        let mockUser: UserInfo = UserInfoMock()
        .set(userId: "123")
        .set(email: "some")
        .build()

        mockUserDataStore = MockUserDataStore()
        mockContext = MockContext()
        mockProvider = MockAnalyticsProvider()

        mockUserDataStore.userToReturn = mockUser

        testObject = KarhooAnalyticsService(providers: [mockProvider],
                                             context: mockContext,
                                             userDataStore: mockUserDataStore)
    }

    /**
     *  Given:  A testflight build
     *  When:   Getting the default providers
     *  Then:   The correct providers should be fetched
     */
    func testDefaultProvidersTestflight() {
        mockContext.isTestflightBuildReturnValue = true
        let providers = KarhooAnalyticsService.defaultProviders(context: mockContext)

        XCTAssertEqual(1, providers.count)
        XCTAssertNotNil(providers[0] as? LogAnalyticsProvider)
    }

    /**
     *  Given:  A regular build
     *  When:   Getting the default providers
     *  Then:   The correct providers should be fetched
     */
    func testDefaultProviders() {
        mockContext.isTestflightBuildReturnValue = false
        let providers = KarhooAnalyticsService.defaultProviders(context: mockContext)

        XCTAssertGreaterThan(providers.count, 0)
    }

    /**
     *  Given:  A set of preferred providers
     *  When:   Constructing an analytics service
     *  Then:   The construction with the custom providers should work
     */
    func testCustomProviders() {
        let firstProvider = MockAnalyticsProvider()
        let secondProvider = MockAnalyticsProvider()

        let analytics = KarhooAnalyticsService(providers: [firstProvider,
                                                            secondProvider],
                                                context: mockContext)
        analytics.send(eventName: .userLoggedIn)

        XCTAssertEqual(AnalyticsConstants.EventNames.userLoggedIn.description, firstProvider.trackedName)
        XCTAssertEqual(AnalyticsConstants.EventNames.userLoggedIn.description, secondProvider.trackedName)
    }

    /**
      * Given: Tracking a GDPR sensitive event
      * When:  The user IS NOT logged in
      * Then:  The event should not be tracked
      */
    func testTrackingGdprEventWhenNotLoggedIn() {
        mockUserDataStore.userToReturn = nil

        testObject.send(eventName: .appOpened, payload: [:])

        XCTAssertNil(mockProvider.trackedName)
    }

    /**
     * Given: Tracking a GDPR sensitive event
     * When:  The user IS logged in
     * Then:  The event should be tracked
     */
    func testTrackingGDPRSensitiveEventUserIsLoggedIn() {
        testObject.send(eventName: .appOpened, payload: [:])

        XCTAssertEqual(AnalyticsConstants.EventNames.appOpened.description, mockProvider.trackedName)
    }

    /**
      * When: Tracking an event that is NOT GDPR sensitive
      * Then: The event should be tracked
      */
    func testTrackingNonGDPRSensitiveEvent() {
        testObject.send(eventName: .userCalledDriver, payload: [:])

        XCTAssertEqual(AnalyticsConstants.EventNames.userCalledDriver.description, mockProvider.trackedName)
    }

    private func checkGenericParameters(payload: [String: Any]?) -> Bool {
        var returnValue = true

        if payload?[AnalyticsConstants.Keys.sendingApp.description] == nil {
            returnValue = false
        }

        if let user = mockUserDataStore.getCurrentUser() {
            returnValue = returnValue && payload?[AnalyticsConstants.Keys.userId.description] as? String == user.userId
        }

        return returnValue
    }
}
