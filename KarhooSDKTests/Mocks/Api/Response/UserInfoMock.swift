//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class UserInfoMock {

    private var user: UserInfo

    init() {
        self.user = UserInfo(userId: "",
                             firstName: "",
                             lastName: "",
                             email: "",
                             mobileNumber: "",
                             organisations: [])
    }

    func set(userId: String) -> UserInfoMock {
        create(userId: userId)
        return self
    }

    func set(firstName: String) -> UserInfoMock {
        create(firstName: firstName)
        return self
    }

    func set(lastName: String) -> UserInfoMock {
        create(lastName: lastName)
        return self
    }

    func set(email: String) -> UserInfoMock {
        create(email: email)
        return self
    }

    func set(mobile: String) -> UserInfoMock {
        create(mobile: mobile)
        return self
    }

    func set(organisation: [Organisation]) -> UserInfoMock {
        create(organisations: organisation)
        return self
    }

    func set(nonce: Nonce?) -> UserInfoMock {
        create(nonce: nonce)
        return self
    }

    func set(paymentProvider: PaymentProvider?) -> UserInfoMock {
        create(paymentProvider: paymentProvider)
        return self
    }
    
    func set(externalId: String) -> UserInfoMock {
        create(externalId: externalId)
        return self
    }

    func build() -> UserInfo {
        return user
    }

    private func create(userId: String = "",
                        firstName: String = "",
                        lastName: String = "",
                        email: String = "",
                        mobile: String = "",
                        organisations: [Organisation] = [],
                        nonce: Nonce? = nil,
                        paymentProvider: PaymentProvider? = nil,
                        externalId: String = "") {
        self.user = UserInfo(userId: userId.isEmpty ? user.userId : userId,
                             firstName: firstName.isEmpty ? user.firstName : firstName,
                             lastName: lastName.isEmpty ? user.lastName : lastName,
                             email: email.isEmpty ? user.email : email,
                             mobileNumber: mobile.isEmpty ? user.mobileNumber : user.mobileNumber,
                             organisations: organisations.isEmpty ? user.organisations : organisations,
                             nonce: nonce == nil ? user.nonce : nonce,
                             externalId: externalId)
        user.paymentProvider = paymentProvider == nil ? self.user.paymentProvider : paymentProvider
    }
}
