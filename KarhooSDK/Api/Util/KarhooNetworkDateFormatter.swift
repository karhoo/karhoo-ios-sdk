//
//  KarhooNetworkDateFormatter.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

/**
 * date format: ISO-8601
 * date_required has to be sent in local time
 * date_scheduled is UTC time. So when we parse dates,
 * we have to provide formatting context (KarhooDateFormat)
--------
 * local time: https://docs.stg.karhoo.net/v1/quotes#quoterequest (date_required)
 * UTC time: https://docs.stg.karhoo.net/v1/bookings#booking (date_scheduled)
 */

public enum KarhooDateFormat: String {
    case booking = "yyyy-MM-dd'T'HH:mm:ssz"
    case availability = "yyyy-MM-dd'T'HH:mm"
}

public final class KarhooNetworkDateFormatter: NetworkDateFormatter {

    private let dateFormatter: DateFormatter

    public init(timeZone: TimeZone? = TimeZone(secondsFromGMT: 0)!,
                formatType: KarhooDateFormat) {
        dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = formatType.rawValue
    }

    func toString(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }

    public func toDate(from string: String) -> Date? {
       return dateFormatter.date(from: string)
    }
}
