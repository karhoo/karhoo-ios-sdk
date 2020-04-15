//
//  UISettings.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

struct UISettings {

    //defaultForKarhooUsers : a1013897-132a-456c-9be2-636979095ad9
    //portalUser: 089a666b-a6ce-4e75-8d7f-12d8f0208f1b
    //b2c Karhoo org: 23661866-6554-46bf-977e-21430a3e1f22
    static var settings: [String: [String: UIConfig]] = ["a1013897-132a-456c-9be2-636979095ad9":
                                                            ["additionalFeedbackButton": UIConfig(hidden: false)],
                                                         "089a666b-a6ce-4e75-8d7f-12d8f0208f1b":
                                                            ["additionalFeedbackButton": UIConfig(hidden: true)],
                                                         "23661866-6554-46bf-977e-21430a3e1f22": ["additionalFeedbackButton": UIConfig(hidden: false)],
                                                         "5fc4f33b-2832-466e-9943-8728589ef727": ["additionalFeedbackButton": UIConfig(hidden: false)]]
}
