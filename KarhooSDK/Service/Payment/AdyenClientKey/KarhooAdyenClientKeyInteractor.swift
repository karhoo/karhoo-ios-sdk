//
// Created by Bartlomiej Sopala on 06/04/2022.
// Copyright (c) 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooAdyenClientKeyInteractor: AdyenPublicKeyInteractor {

    private let adyenClientKeyRequestSender: RequestSender

    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        adyenClientKeyRequestSender = requestSender
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        adyenClientKeyRequestSender.requestAndDecode(payload: nil, endpoint: .adyenClientKey, callback: callback)
    }

    func cancel() {
        adyenClientKeyRequestSender.cancelNetworkRequest()
    }
}

