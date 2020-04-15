//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooAvailabilityInteractor: AvailabilityInteractor {

    private let requestSender: RequestSender
    private var availabilitySearch: AvailabilitySearch?

    init(request: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.requestSender = request
    }

    func set(availabilitySearch: AvailabilitySearch) {
        self.availabilitySearch = availabilitySearch
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        guard let availabilitySearch = self.availabilitySearch else {
            return
        }

        requestSender.requestAndDecode(payload: availabilitySearch,
                                       endpoint: .availability,
                                       callback: callback)
    }

    func cancel() {
        requestSender.cancelNetworkRequest()
    }
}
