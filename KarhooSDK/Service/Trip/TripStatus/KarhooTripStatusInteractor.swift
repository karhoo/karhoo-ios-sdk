//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooTripStatusInteractor: TripStatusInteractor {
    private let tripId: String
    private let requestSender: RequestSender

    init(tripId: String,
         requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.tripId = tripId
        self.requestSender = requestSender
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        requestSender.requestAndDecode(payload: nil,
                                       endpoint: .tripStatus(identifier: tripId),
                                       callback: { (result: Result<TripStatus>) in
                                        guard let status = result.successValue(orErrorCallback: callback),
                                            let resultValue = status.status as? T else { return }
                                        callback(.success(result: resultValue))

        })
    }

    func cancel() {
        requestSender.cancelNetworkRequest()
    }
}
