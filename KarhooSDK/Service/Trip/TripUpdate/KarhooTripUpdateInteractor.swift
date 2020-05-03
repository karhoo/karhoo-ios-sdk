//
//  KarhooTripUpdateInteractor.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooTripUpdateInteractor: TripUpdateInteractor {

    private let identifier: String
    private let requestSender: RequestSender

    init(tripId: String,
         requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared)) {
        self.identifier = tripId
        self.requestSender = requestSender
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        requestSender.requestAndDecode(payload: nil,
                                       endpoint: endpoint(),
                                       callback: { [weak self] (result: Result<TripInfo>) in
                                        switch result {
                                        case .success(var response):
                                            self?.addFollowCodeToResponse(&response)

                                            guard let trip = response as? T else {
                                                return
                                            }

                                            callback(.success(result: trip))
                                        case .failure(let error):
                                            callback(.failure(error: error))
                                        }
        })
    }

    func cancel() {
        requestSender.cancelNetworkRequest()
    }

    private func endpoint() -> APIEndpoint {
        if Karhoo.configuration.authenticationMethod().isGuest() {
            return .trackTripFollowCode(followCode: identifier)
        }
        return .trackTrip(identifier: identifier)
    }

    private func addFollowCodeToResponse(_ trip: inout TripInfo) {
        if Karhoo.configuration.authenticationMethod().isGuest() {
            trip.followCode = identifier
        }
    }
}
