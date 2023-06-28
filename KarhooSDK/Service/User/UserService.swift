//
//  UserService.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public protocol UserStateObserver: AnyObject {
    func userStateUpdated(user: UserInfo?)
}

public protocol UserService {

    func logout() -> Call<KarhooVoid>
    func getCurrentUser() -> UserInfo?
    func passwordReset(email: String) -> Call<KarhooVoid>
    func updateUserDetails(update: UserDetailsUpdateRequest) -> Call<UserInfo>
    func register(userRegistration: UserRegistration) -> Call<UserInfo>
    func add(observer: UserStateObserver)
    func remove(observer: UserStateObserver)

}
