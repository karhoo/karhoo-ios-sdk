//
//  TimestampFormatter.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public final class TimestampFormatter {
    private let timestampFormatter: DateFormatter

    public init() {
        timestampFormatter = DateFormatter()
        timestampFormatter.timeZone = TimeZone.current
        timestampFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }

    public func formattedDate(_ date: Date) -> String {
        return timestampFormatter.string(from: date)
    }
}
