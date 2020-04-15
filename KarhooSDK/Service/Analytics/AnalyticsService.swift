//
//  AnalyticsService.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public protocol AnalyticsService {

    func send(eventName: AnalyticsConstants.EventNames, payload: [String: Any])
    
    func send(eventName: AnalyticsConstants.EventNames)
} 
