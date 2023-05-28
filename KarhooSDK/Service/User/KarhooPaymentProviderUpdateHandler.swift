//
// Created by Bartlomiej Sopala on 18/07/2022.
//

import Foundation

class KarhooPaymentProviderUpdateHandler: PaymentProviderUpdateHandler {

    private let userDataStore: UserDataStore
    private let nonceRequestSender: RequestSender
    private let paymentProviderRequest: RequestSender
    private let loyaltyProviderRequest: RequestSender

    init(
        userDataStore: UserDataStore = DefaultUserDataStore(),
        nonceRequestSender: RequestSender,
        paymentProviderRequest: RequestSender,
        loyaltyProviderRequest: RequestSender
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
                let paymentProvider = result.getSuccessValue()
                guard let self = self else { return }
                self.userDataStore.updatePaymentProvider(paymentProvider: paymentProvider)
                LoyaltyUtils.updateLoyaltyStatusFor(
                    paymentProvider: paymentProvider,
                    userDataStore: self.userDataStore,
                    loyaltyProviderRequest: self.loyaltyProviderRequest
                )
            }
        )
    }
}
