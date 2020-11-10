//
//  KarhooCoverageInteractor.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 10/11/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooCoverageInteractor: CoverageInteractor {
    private var coverageRequestSender: RequestSender
    private var coverageRequest: CoverageRequest?
    
    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.coverageRequestSender = requestSender
    }
    
    func set(coverageRequest: CoverageRequest) {
        self.coverageRequest = coverageRequest
    }
    
    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        coverageRequestSender.requestAndDecode(payload: nil, endpoint: .coverage, callback: callback)
    }
    
    func cancel() {
        coverageRequestSender.cancelNetworkRequest()
    }
}
