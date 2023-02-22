//
//  ServiceAgreements.swift
//  KarhooSDK
//
//  Created by Edward Wilkins on 17/02/2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct ServiceAgreements: KarhooCodableModel {
    
    public let serviceCancellation: ServiceCancellation
    public let serviceWaiting: ServiceWaiting
    
    public init(serviceCancellation: ServiceCancellation = ServiceCancellation(),
                serviceWaiting: ServiceWaiting = ServiceWaiting()) {
        self.serviceCancellation = serviceCancellation
        self.serviceWaiting = serviceWaiting
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.serviceCancellation = (try? container.decodeIfPresent(ServiceCancellation.self, forKey: .serviceCancellation)) ?? ServiceCancellation()
        self.serviceWaiting = (try? container.decodeIfPresent(ServiceWaiting.self, forKey: .serviceWaiting)) ?? ServiceWaiting()
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(serviceCancellation, forKey: .serviceCancellation)
        try container.encode(serviceWaiting, forKey: .serviceWaiting)
    }
    
    enum CodingKeys: String, CodingKey {
        case serviceCancellation = "free_cancellation"
        case serviceWaiting = "free_waiting_time"
    }
}
