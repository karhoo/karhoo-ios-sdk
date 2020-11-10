//
//  KarhooCoverageInteractor.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 10/11/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooQuoteCoverageInteractor: QuoteCoverageInteractor {
    private var coverageRequestSender: RequestSender
    private var coverageRequest: QuoteCoverageRequest?
    
    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.coverageRequestSender = requestSender
    }
    
    func set(coverageRequest: QuoteCoverageRequest) {
        self.coverageRequest = coverageRequest
    }
    
    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        coverageRequestSender.requestAndDecode(payload: coverageRequest, endpoint: .quoteCoverage, callback: callback)
    }
    
    func cancel() {
        coverageRequestSender.cancelNetworkRequest()
    }
}
