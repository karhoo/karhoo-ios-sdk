//
//  AdyenPaymentAPIVersion.swift
//  KarhooSDK
//
//  Created by Aleksander Wedrychowski on 06/04/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

protocol AdyenAPIVersionProvider {
    func getVersion() -> String
}
