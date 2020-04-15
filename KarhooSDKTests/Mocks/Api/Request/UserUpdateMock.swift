//
//  UserUpdateMock.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class UserUpdateMock {
    
    private var userUpdateDetails: UserDetailsUpdateRequest
    
    init() {
        userUpdateDetails = UserDetailsUpdateRequest(firstName: "",
                                                     lastName: "",
                                                     phoneNumber: "",
                                                     locale: "",
                                                     avatarURL: "")
    }
    
    func set(firstName: String) -> UserUpdateMock {
        create(firstName: firstName)
        return self
    }
    
    func set(lastName: String) -> UserUpdateMock {
        create(lastName: lastName)
        return self
    }
    
    func set(phoneNumber: String) -> UserUpdateMock {
        create(phoneNumber: phoneNumber)
        return self
    }
    
    func set(locale: String?) -> UserUpdateMock {
        create(locale: locale)
        return self
    }
    
    func set(avatarURL: String) -> UserUpdateMock {
        create(avatarURL: avatarURL)
        return self
    }
    
    private func create(firstName: String? = nil,
                        lastName: String? = nil,
                        phoneNumber: String? = nil,
                        locale: String? = nil,
                        avatarURL: String? = nil) {
        userUpdateDetails = UserDetailsUpdateRequest(firstName: firstName ?? userUpdateDetails.firstName,
                                                     lastName: lastName ?? userUpdateDetails.lastName,
                                                     phoneNumber: phoneNumber ?? userUpdateDetails.phoneNumber,
                                                     locale: locale ?? userUpdateDetails.locale,
                                                     avatarURL: avatarURL ?? userUpdateDetails.avatarURL)
    }
    
    func build() -> UserDetailsUpdateRequest {
        return userUpdateDetails
    }
}
