//
//  KarhooCodableModel.Swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public protocol KarhooCodableModel: Encodable, Decodable, KarhooRequestModel {
    func encode() -> Data?

    func equals(_ item: KarhooCodableModel) -> Bool
}

public protocol KarhooRequestModel: Encodable {
    func encode() -> Data?
}

extension KarhooRequestModel {
    public func encode() -> Data? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .sortedKeys
            return try encoder.encode(self)
        } catch let error {
            print("----Error Encoding model: \(self) | Reason: \(error.localizedDescription)")
            return nil
        }
    }
}

extension KarhooCodableModel {

    public func encode() -> Data? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .sortedKeys
            return try encoder.encode(self)
        } catch let error {
            print("----Error Encoding model: \(self) | Reason: \(error.localizedDescription)")
            return nil
        }
    }

    public func equals(_ item: KarhooCodableModel) -> Bool {
        return self.encode() == item.encode()
    }
}

extension Array: KarhooCodableModel, KarhooRequestModel where Element: KarhooCodableModel {}

struct Constants { static let currencyDecimalFactor = 0.01 }
