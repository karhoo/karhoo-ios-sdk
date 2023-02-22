//
//  CancellationFee.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 01/12/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct CancellationFee: KarhooCodableModel {

    public let cancellationFee: Bool
    public let fee: CancellationFeePrice

    public init(cancellationFee: Bool = false,
                    fee: CancellationFeePrice = CancellationFeePrice()) {
        self.cancellationFee = cancellationFee
        self.fee = fee
    }

    enum CodingKeys: String, CodingKey {
        case cancellationFee = "cancellation_fee"
        case fee
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cancellationFee = (try? container.decodeIfPresent(Bool.self, forKey: .cancellationFee)) ?? false
        self.fee = (try? container.decodeIfPresent(CancellationFeePrice.self, forKey: .fee)) ?? CancellationFeePrice()
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cancellationFee, forKey: .cancellationFee)
        try container.encode(fee, forKey: .fee)
    }
}
