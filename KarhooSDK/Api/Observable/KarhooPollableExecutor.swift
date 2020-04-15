//
//  KarhooPollExecutor
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public protocol KarhooPollExecutor {
    var executable: KarhooExecutable { get }

    func startPolling<T: KarhooCodableModel>(pollTime: TimeInterval,
                                             callback: @escaping CallbackClosure<T>)
    func stopPolling()
}

final class PollExecutor: KarhooPollExecutor {

    public let executable: KarhooExecutable
    private let pollingScheduler: TimingScheduler

    init(pollingScheduler: TimingScheduler = KarhooTimingScheduler(),
         executable: KarhooExecutable) {
        self.pollingScheduler = pollingScheduler
        self.executable = executable
    }

    func startPolling<T: KarhooCodableModel>(pollTime: TimeInterval,
                                             callback: @escaping CallbackClosure<T>) {
        let executableBlock: (() -> Void) = { [weak self] in
            self?.executable.execute(callback: callback)
        }

        pollingScheduler.fireAndSchedule(block: executableBlock,
                                         in: pollTime,
                                         repeats: true)
    }

    func stopPolling() {
        pollingScheduler.invalidate()
        executable.cancel()
    }
}
