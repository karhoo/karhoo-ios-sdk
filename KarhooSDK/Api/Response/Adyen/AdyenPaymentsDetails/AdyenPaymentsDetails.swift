//
//  AdyenPaymentsDetails.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 01/09/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenPaymentsDetails: KarhooCodableModel {
    
    public let action: AdyenAction
    public let amount: AdyenAmount

    public init(action: AdyenAction = AdyenAction(),
                amount: AdyenAmount = AdyenAmount()
                ) {
        self.action = action
        self.amount = amount
    }
    
    enum CodingKeys: String, CodingKey {
        case action
        case amount
    }
    
   public init(from decoder: Decoder) throws {
          let container = try decoder.container(keyedBy: CodingKeys.self)
          self.action = (try? container.decode(AdyenAction.self, forKey: .action)) ?? AdyenAction()
          self.amount = (try? container.decode(AdyenAmount.self, forKey: .amount)) ?? AdyenAmount()
      }
      
      public func encode(to encoder: Encoder) throws {
          var container = encoder.container(keyedBy: CodingKeys.self)
          try container.encode(action, forKey: .action)
          try container.encode(amount, forKey: .amount)
      }
}
