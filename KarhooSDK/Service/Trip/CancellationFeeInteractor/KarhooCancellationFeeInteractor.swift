//
//  KarhooCancellationFeeInteractor.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 02/12/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooCancellationFeeInteractor: CancellationFeeInteractor {
    
    private let requestSender: RequestSender
    private var identifier: String?

    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.requestSender = requestSender
    }
    
    func set(identifier: String) {
        self.identifier = identifier
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        requestSender.requestAndDecode(payload: nil,
                                       endpoint: endpoint(identifier: identifier ?? ""),
                                       callback: callback)
    }

    func cancel() {
        requestSender.cancelNetworkRequest()
    }
    
    private func endpoint(identifier: String) -> APIEndpoint {
        if Karhoo.configuration.authenticationMethod().isGuest() {
            return .cancellationFeeFollowCode(followCode: identifier)
        }

        return .cancellationFee(identifier: identifier)
    }
}
