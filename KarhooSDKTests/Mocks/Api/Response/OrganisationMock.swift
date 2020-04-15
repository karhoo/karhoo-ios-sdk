//
//  OrganisationMock.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooSDK

final class OrganisationMock {

    private var organisation: Organisation

    init() {
        self.organisation = Organisation(id: "",
                                         name: "",
                                         roles: [""])
    }

    func set(id: String) -> OrganisationMock {
        create(id: id)
        return self
    }

    func set(name: String) -> OrganisationMock {
        create(name: name)
        return self
    }

    func set(roles: [String]) -> OrganisationMock {
        create(roles: roles)
        return self
    }

    func build() -> Organisation {
        return organisation
    }
    
    private func create(id: String = "",
                        name: String = "",
                        roles: [String] = [""]) {
        self.organisation = Organisation(id: id.isEmpty ? organisation.id : id,
                                         name: name.isEmpty ? organisation.name : name,
                                         roles: roles.isEmpty ? organisation.roles : roles)

    }
}
