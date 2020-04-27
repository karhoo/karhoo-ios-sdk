//
//  KarhooCancelTripInteractor.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooCancelTripInteractor: CancelTripInteractor {

    private let requestSender: RequestSender
    private let analyticsService: AnalyticsService
    private var tripCancellation: TripCancellation?

    init(requestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
         analyticsService: AnalyticsService = KarhooAnalyticsService()) {
        self.requestSender = requestSender
        self.analyticsService = analyticsService
    }

    func set(tripCancellation: TripCancellation) {
        self.tripCancellation = tripCancellation
    }

    func execute<T: KarhooCodableModel>(callback: @escaping CallbackClosure<T>) {
        guard let tripCancellation = self.tripCancellation else {
            return
        }

        let payload = CancelTripRequestPayload(reason: tripCancellation.cancelReason)

        requestSender.request(payload: payload,
                              endpoint: endpoint(identifier: tripCancellation.tripId),
                              callback: { result in
                                guard result.successValue(orErrorCallback: callback) != nil,
                                    let resultValue = KarhooVoid() as? T else { return }
                                callback(Result.success(result: resultValue))
        })

        analyticsService.send(eventName: .tripCancellationAttempted)
    }

    func cancel() {
        requestSender.cancelNetworkRequest()
    }

    private func endpoint(identifier: String) -> APIEndpoint {
        if Karhoo.configuration.authenticationMethod().isGuest() {
            return .cancelTripFollowCode(followCode: identifier)
        }

        return .cancelTrip(identifier: identifier)
    }
}
