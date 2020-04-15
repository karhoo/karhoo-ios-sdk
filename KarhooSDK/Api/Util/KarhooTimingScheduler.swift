//
//  KarhooTimingScheduler.swift
//  Karhoo
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public protocol TimingScheduler {
    func fireAndSchedule(block: @escaping () -> Void, in timeInterval: TimeInterval, repeats: Bool)
    func invalidate()
}

public final class KarhooTimingScheduler: TimingScheduler {
    private var timer: Timer?
    private var block: (() -> Void)?
    private var repeats: Bool?

    public init() { }

    public func fireAndSchedule(block: @escaping () -> Void, in timeInterval: TimeInterval, repeats: Bool) {
        invalidate()
        self.block = block
        self.repeats = repeats
        fire()
        timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                     target: self,
                                     selector: #selector(KarhooTimingScheduler.fire),
                                     userInfo: nil,
                                     repeats: repeats)
    }

    @objc private func fire() {
        block?()
    }

    public func invalidate() {
        timer?.invalidate()
        timer = nil
    }
}
