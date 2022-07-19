//
//  KarhooVehicleRulesInteractor.swift
//  KarhooSDK
//
//  Created by Aleksander Wedrychowski on 19/07/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooVehicleRulesInteractor: VehicleRulesInteractor {
    private var requestSender: RequestSender

    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.requestSender = requestSender
    }

    func execute<T>(callback: @escaping CallbackClosure<T>) where T : KarhooCodableModel {
       
        requestSender.requestAndDecode(
            payload: nil,
            endpoint: .vehicleRules,
            callback: callback
        )
    }
    
    func cancel() {
        requestSender.cancelNetworkRequest()
    }
}
