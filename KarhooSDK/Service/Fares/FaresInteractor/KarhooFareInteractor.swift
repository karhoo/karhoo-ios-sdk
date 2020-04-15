//
//  KarhooFareInteractor.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooFareInteractor: FareInteractor {
    
    private var tripId: String?
    private let requestSender: RequestSender
    
    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.requestSender = requestSender
    }
    
    func execute<T>(callback: @escaping (Result<T>) -> Void) where T: KarhooCodableModel {
        guard let tripId = self.tripId else {
            return
        }
        
        requestSender.requestAndDecode(payload: nil,
                                       endpoint: .getFareDetails(identifier: tripId),
                                       callback: callback)
    }
    
    func cancel() {
        requestSender.cancelNetworkRequest()
    }
    
    func set(tripId: String) {
        self.tripId = tripId
    }
}
