//
//  AdyenPaymentsResponse.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 25/08/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenPaymentsResponse: KarhooCodableModel {
    public let transactionID: String
    public let payload: AdyenPayments
    
    public init(transactionID: String = "",
                payload: AdyenPayments = AdyenPayments()) {
        self.transactionID = transactionID
        self.payload = payload
    }
    
    enum CodingKeys: String, CodingKey {
        case transactionID = "transaction_id"
        case payload
    }
    
    public init(from decoder: Decoder) throws {
          let container = try decoder.container(keyedBy: CodingKeys.self)
          self.transactionID = (try? container.decode(String.self, forKey: .transactionID)) ?? ""
          self.payload = (try? container.decode(AdyenPayments.self, forKey: .payload)) ?? AdyenPayments()
      }

      public func encode(to encoder: Encoder) throws {
          var container = encoder.container(keyedBy: CodingKeys.self)
          try container.encode(transactionID, forKey: .transactionID)
          try container.encode(payload, forKey: .payload)
      }
}
