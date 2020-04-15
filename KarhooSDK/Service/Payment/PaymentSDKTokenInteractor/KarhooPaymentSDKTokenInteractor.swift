//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooPaymentSDKTokenInteractor: PaymentSDKTokenInteractor {

    private let paymentSDKTokenRequest: RequestSender
    private var requestPayload: PaymentSDKTokenPayload?

    init(request: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.paymentSDKTokenRequest = request
    }

    func set(payload: PaymentSDKTokenPayload) {
        self.requestPayload = payload
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        guard let payload = self.requestPayload else {
            return
        }

        paymentSDKTokenRequest.requestAndDecode(payload: nil,
                                                endpoint: .paymentSDKToken(payload: payload),
                                                callback: callback)
    }

    func cancel() {
        paymentSDKTokenRequest.cancelNetworkRequest()
    }
}
