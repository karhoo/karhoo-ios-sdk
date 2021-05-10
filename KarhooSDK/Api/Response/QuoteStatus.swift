//
//  QuoteStatus.swift
//  KarhooSDK
//
//  Created by Edward Wilkins on 22/01/2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public enum QuoteStatus: String, Codable {
    case `default` = "DEFAULT"
    case progressing = "PROGRESSING"
    case completed = "COMPLETED"
}
