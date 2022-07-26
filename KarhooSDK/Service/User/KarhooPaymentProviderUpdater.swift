//
// Created by Bartlomiej Sopala on 18/07/2022.
//

import Foundation

class KarhooPaymentProviderUpdater: PaymentProviderUpdater {

    private let userDataStore: UserDataStore
    private let nonceRequestSender: RequestSender
    private let paymentProviderRequest: RequestSender
    private let loyaltyProviderRequest: RequestSender

    init(
        userDataStore: UserDataStore = DefaultUserDataStore(),
        nonceRequestSender: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
        paymentProviderRequest: RequestSender = KarhooRequestSender(httpClient: TokenRefreshingHttpClient.shared),
        loyaltyProviderRequest: RequestSender = KarhooRequestSender(httpClient: JsonHttpClient.shared)
    ) {
        self.userDataStore = userDataStore
        self.nonceRequestSender = nonceRequestSender
        self.paymentProviderRequest = paymentProviderRequest
        self.loyaltyProviderRequest = loyaltyProviderRequest
    }

    func updatePaymentProvider(user: UserInfo) {
        paymentProviderRequest.requestAndDecode(
            payload: nil,
            endpoint: .paymentProvider,
            callback: { [weak self] (result: Result<PaymentProvider>) in
                let paymentProvider = result.successValue()
                self?.userDataStore.updatePaymentProvider(paymentProvider: paymentProvider)
                if result.successValue()?.provider.type == .braintree {
                    self?.updateUserNonce(user: user)
                }
                guard let self = self else { return }
                LoyaltyUtils.updateLoyaltyStatusFor(
                    paymentProvider: paymentProvider,
                    userDataStore: self.userDataStore,
                    loyaltyProviderRequest: self.loyaltyProviderRequest
                )
            }
        )
    }

    private func updateUserNonce(user: UserInfo) {
        let payload = NonceRequestPayload(
            payer: Payer(user: user),
            organisationId: user.organisations.first?.id ?? ""
        )

        nonceRequestSender.requestAndDecode(payload: payload,
            endpoint: .getNonce) { [weak self] (result: Result<Nonce>) in
            self?.userDataStore.updateCurrentUserNonce(nonce: result.successValue())
        }
    }
}