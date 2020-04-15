//
//  MockTimingScheduler.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooSDK

final class MockTimingScheduler: TimingScheduler {

    private(set) var scheduled = false
    private(set) var capturedBlock: (() -> Void)?
    private(set) var capturedRepeats: Bool?
    private(set) var timeIntervalSet: TimeInterval?
    func fireAndSchedule(block: @escaping () -> Void, in timeInterval: TimeInterval, repeats: Bool) {
        scheduled = true
        capturedBlock = block
        capturedRepeats = repeats
        invalidateCalled = false
        timeIntervalSet = timeInterval
    }

    func fire() {
        if capturedRepeats == false {
            scheduled = false
        }

        capturedBlock?()
    }

    private(set) var invalidateCalled = false
    func invalidate() {
        scheduled = false
        invalidateCalled = true
    }
}
