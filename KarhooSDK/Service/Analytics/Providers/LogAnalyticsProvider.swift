//
//  LogAnalyticsProvider.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class LogAnalyticsProvider: AnalyticsProvider {

    private let newLine = "\n"
    private let delimiter = "\n-----------------\n"
    private let nameTitle = "Event: "
    private let payloadDelimiter = ": "

    private let output: (String, CVarArg...) -> Void

    init(output: @escaping (String, CVarArg...) -> Void = NSLog) {
        self.output = output
    }

    func trackEvent(name: String) {
        output(delimiter + nameTitle + name.description + delimiter)
    }

    func trackEvent(name: String, payload: [String: Any]?) {
        output(delimiter + nameTitle + name.description + newLine)
        let payloadToUse = payload ?? [:]
        for (key, value) in payloadToUse {
            output(key + payloadDelimiter + "\(value)" + newLine)
        }
        output(delimiter)
    }
}
